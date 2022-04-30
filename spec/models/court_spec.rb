require 'rails_helper'

describe Court do
  subject { described_class.build(data) }

  let(:data) {
    {
      "name" => 'Court name',
      "slug" => 'court-slug',
      "email" => 'family@court',
      "addresses" => ['address'],
      "county_location_code" => 123,
      "gbs" => 'X123',
    }
  }

  describe 'REFRESH_DATA_AFTER' do
    it { expect(described_class::REFRESH_DATA_AFTER).to eq(72.hours) }
  end

  describe '.build' do
    it 'sets the name' do
      expect(subject.name).to eq('Court name')
    end

    it 'sets the slug' do
      expect(subject.slug).to eq('court-slug')
    end

    it 'sets the address' do
      expect(subject.address).to eq('address')
    end

    # Before the FACT release is in place TODO to remove it after
    context 'single address' do
      let(:data) {
        {
          "name" => 'Court name',
          "slug" => 'court-slug',
          "email" => 'family@court',
          "address" => 'address',
          "county_location_code" => 123,
          "gbs" => 'X123',
        }
      }

      it 'sets the address' do
        expect(subject.address).to eq('address')
      end
    end

    it 'sets the cci_code' do
      expect(subject.cci_code).to eq(123)
    end

    it 'sets the gbs code' do
      expect(subject.gbs).to eq('X123')
    end

    context 'log and raise exception when attributes not found' do
      context 'name' do
        let(:data) { super().except('name') }

        it 'sends the exception to Sentry with extra context' do
          expect(Raven).to receive(:extra_context).with(data: data)
          expect(Raven).to receive(:capture_exception).with(an_instance_of(KeyError))
          expect { subject.name }.to raise_error(KeyError, 'key not found: "name"')
        end
      end

      context 'slug' do
        let(:data) { super().except('slug') }

        it 'sends the exception to Sentry with extra context' do
          expect(Raven).to receive(:extra_context).with(data: data)
          expect(Raven).to receive(:capture_exception).with(an_instance_of(KeyError))
          expect { subject.name }.to raise_error(KeyError, 'key not found: "slug"')
        end
      end

      context 'address' do
        let(:data) { super().except('addresses') }

        it 'sends the exception to Sentry with extra context' do
          expect(Raven).to receive(:extra_context).with(data: data)
          expect(Raven).to receive(:capture_exception).with(an_instance_of(KeyError))
          expect { subject.name }.to raise_error(KeyError, 'key not found: "addresses"')
        end
      end

      context 'cci_code' do
        let(:data) { super().except('county_location_code') }

        it 'sends the exception to Sentry with extra context' do
          expect(Raven).to receive(:extra_context).with(data: data)
          expect(Raven).to receive(:capture_exception).with(an_instance_of(KeyError))
          expect { subject.name }.to raise_error(KeyError, 'key not found: "county_location_code"')
        end
      end
    end

    context 'gbs' do
      context 'there is a gbs code in the data provided' do
        it 'sets the gbs' do
          expect(subject.gbs).to eq('X123')
        end

        it 'does not request the gbs from the API' do
          expect(subject).not_to receive(:retrieve_gbs_from_api)
          subject.gbs
        end
      end

      context 'there is no gbs code in the data provided' do
        let(:data) { super().except('gbs') }

        before do
          allow_any_instance_of(
            C100App::CourtfinderAPI
          ).to receive(:court_lookup).with('court-slug').and_return(api_response)
        end

        context 'the API returned gbs' do
          let(:api_response) do
            { 'gbs' => 'A123' }
          end

          it 'sets the gbs code' do
            expect(subject.gbs).to eq('A123')
          end
        end

        context 'the API returned a `nil` gbs' do
          let(:api_response) do
            { 'gbs' => nil }
          end

          it 'sets the gbs fallback code' do
            expect(subject.gbs).to eq('unknown')
          end
        end

        context 'the API returned a blank gbs' do
          let(:api_response) do
            { 'gbs' => '' }
          end

          it 'sets the gbs fallback code' do
            expect(subject.gbs).to eq('unknown')
          end
        end

        context 'the API failed to return gbs' do
          let(:api_response) { {} }
          it { expect { subject.gbs }.to raise_error(KeyError, 'key not found: "gbs"') }
        end
      end
    end

    context 'email' do
      context 'there is an email in the data provided' do
        it 'sets the email' do
          expect(subject.email).to eq('family@court')
        end

        it 'does not request the list of emails from the API' do
          expect(subject).not_to receive(:retrieve_emails_from_api)
          subject.email
        end
      end

      context 'there is no email in the data provided' do
        let(:data) { super().except('email') }

        before do
          allow_any_instance_of(
            C100App::CourtfinderAPI
          ).to receive(:court_lookup).with('court-slug').and_return(api_response)
        end

        context 'the API returned emails' do
          let(:api_response) do
            { 'emails' => [{"description" => "applications", "address" => "applications@email"}] }
          end

          it 'sets the email' do
            expect(subject.email).to eq('applications@email')
          end
        end

        context 'the API failed to return emails' do
          let(:api_response) { {} }
          it { expect { subject.email }.to raise_error(KeyError, 'key not found: "emails"') }
        end
      end
    end
  end

  describe '.create_or_refresh' do
    subject { described_class.create_or_refresh(data) }

    let(:slug) { 'court-test-7fb3d126d5e0' }
    let(:data) {
      {
        "slug" => slug,
        "name" => 'Court Test',
        "address" => {},
        "county_location_code" => 123,
        "email" => nil,
        "gbs" => nil,
      }
    }

    before do
      allow_any_instance_of(Court).to receive(:best_enquiries_email).and_return('family@court')
      allow_any_instance_of(Court).to receive(:retrieve_gbs_from_api).and_return('X123')
    end

    # Note: following tests are easier and more accurate if we use real records
    # persisted to database instead of doubles, thus we need to ensure a fresh state.
    #
    before { Court.where(slug: 'court-test-7fb3d126d5e0').destroy_all }
    after  { Court.where(slug: 'court-test-7fb3d126d5e0').destroy_all }

    context 'log and raise exception if an error occurs' do
      before do
        allow(Court).to receive(:find_or_initialize_by).and_raise(StandardError, 'boom!')
      end

      it 'sends the exception to Sentry with extra context' do
        expect(Raven).to receive(:extra_context).with(data: data)
        expect(Raven).to receive(:capture_exception).with(an_instance_of(StandardError))

        expect { subject }.to raise_error(StandardError, 'boom!')
      end
    end

    context 'for a new court record, not in the database' do
      it 'creates a new court and returns it' do
        expect {
          @court = subject
        }.to change { Court.where(slug: slug).count }.from(0).to(1)

        expect(
          @court.attributes
        ).to include(
          'name' => 'Court Test',
          'email' => 'family@court',
          'address' => {},
          'cci_code' => 123,
          'gbs' => 'X123'
        )
      end
    end

    context 'for an existing court record in the database' do
      context 'with stale data' do
        let!(:court) {
          Court.create(data.merge("email" => 'family@court', "gbs" => 'X123'))
        }

        before do
          @updated_at = 4.days.from_now
          travel_to @updated_at
        end

        context 'and some data has changed' do
          before do
            allow_any_instance_of(Court).to receive(:best_enquiries_email).and_return('updated-email')
            allow_any_instance_of(Court).to receive(:retrieve_gbs_from_api).and_return('updated-gbs')
          end

          it 'forces a refresh of the data' do
            expect(
              subject.attributes
            ).to include('email' => 'updated-email', 'gbs' => 'updated-gbs')
          end

          it 'touches the `updated_at` timestamp' do
            expect(subject.updated_at.to_i).to eq(@updated_at.to_i)
          end
        end

        context 'and the same data is still in use' do
          it 'maintains the same data' do
            expect(
              subject.attributes
            ).to include('email' => 'family@court', 'gbs' => 'X123')
          end

          it 'touches the `updated_at` timestamp' do
            expect(subject.updated_at.to_i).to eq(@updated_at.to_i)
          end
        end
      end

      context 'without stale data' do
        let(:court) { instance_double(Court) }

        before do
          allow(Court).to receive(:find_or_initialize_by).and_return(court)
        end

        it 'does not refresh the data' do
          expect(court).to receive(:stale?).and_return(false)
          expect(court).not_to receive(:update_attributes)

          expect(subject).to eq(court)
        end
      end
    end
  end

  describe '#best_enquiries_email' do
    before do
      allow(subject).to receive(:retrieve_emails_from_api).and_return(emails)
    end

    context 'email list is empty' do
      let(:emails){ [] }
      it { expect { subject.best_enquiries_email }.to raise_error(KeyError, 'key not found: "address"') }
    end

    context 'email list is not empty but wrong format' do
      let(:emails){ [{"key" => "value"}] }
      it { expect { subject.best_enquiries_email }.to raise_error(KeyError, 'key not found: "address"') }
    end

    context 'given an array of email hashes' do
      context 'containing an email with explanation matching "c100"' do
        let(:emails){
          [
            {
              'description' => 'Enquiries',
              'explanation' => 'Enquiries',
              'address' => 'email1@email',
            },
            {
              'description' => 'All Children Enquiries',
              'explanation' => 'Including C100 Applications',
              'address' => 'email2@email'
            }
          ]
        }

        it 'returns the email address of the matching explanation' do
          expect(subject.best_enquiries_email).to eq('email2@email')
        end

        context 'and containing an email with address matching "family"' do
          let(:emails){
            [
              {
                'description' => 'All other enquiries',
                'address' => 'enquiries@email'
              },
              {
                'description' => 'All Family Enquiries',
                'address' => 'family@email'
              }
            ]
          }

          it 'returns the email address matching family' do
            expect(subject.best_enquiries_email).to eq('family@email')
          end

          context 'and containing an email with address matching "c100"' do
            let(:emails){
              [
                {
                  'description' => 'Applications',
                  'address' => 'c100.applications@email'
                },
                {
                  'description' => 'All Family Enquiries',
                  'address' => 'enquiries@email'
                }
              ]
            }
            it 'returns the email address matching c100' do
              expect(subject.best_enquiries_email).to eq('c100.applications@email')
            end
          end
        end

        context 'and containing an email matching "enquiries"' do
          let(:emails){
            [
              {
                'description' => 'Enquiries',
                'address' => 'enquiries@email',
              },
              {
                'description' => 'All children things',
                'address' => 'children@email'
              },
            ]
          }

          it 'returns the email address matching children' do
            expect(subject.best_enquiries_email).to eq('children@email')
          end
        end
      end

      context 'containing an email with address matching "c100" or "family"' do
        let(:emails) {
          [
            {
              'description' => 'Anything',
              'explanation' => 'family queries',
              'address' => 'family@example',
            },
            {
              'description' => 'C100 applications',
              'address' => 'c100@email'
            }
          ]
        }

        it 'returns the matching email address based on priority' do
          expect(subject.best_enquiries_email).to eq('c100@email')
        end
      end

      context 'containing email addresses matching "children" or "family"' do
        let(:emails){
          [
            {
              'description' => 'Anything',
              'address' => 'Family@email'
            },
            {
              'description' => '',
              'explanation' => 'Explanation',
              'address' => 'Children@email',
            },
          ]
        }

        it 'returns the matching email address based on priority' do
          expect(subject.best_enquiries_email).to eq('Family@email')
        end
      end

      context 'nothing matches except the enquiries email address' do
        let(:emails){
          [
            {
              'description' => 'Should not match anything',
              'address' => 'my@email',
            },
            {
              'description' => 'No address',
            },
            {
              'description' => 'Any description',
              'address' => 'Enquiries@email',
            },
          ]
        }
        it 'returns the `enquiries` email' do
          expect(subject.best_enquiries_email).to eq('Enquiries@email')
        end
      end

      context 'that is not empty but matches no other criterion' do
        let(:emails){
          [
            {
              'description' => 'Should not match anything',
              'address' => 'my@email',
            },
            {
              'description' => 'Another non-matching email',
              'address' => 'not@this.one'
            }
          ]
        }
        it 'returns the first email' do
          expect(subject.best_enquiries_email).to eq('my@email')
        end
      end
    end
  end

  describe '#gbs_known?' do
    context 'for a valid GBS code' do
      it 'returns true' do
        expect(subject.gbs_known?).to eq(true)
      end
    end

    context 'for an unknown GBS code' do
      it 'returns false' do
        expect(subject).to receive(:gbs).and_return('unknown')
        expect(subject.gbs_known?).to eq(false)
      end
    end
  end

  describe '#stale?' do
    before do
      freeze_time
      allow(subject).to receive(:updated_at).and_return(updated_at)
    end

    after { travel_back }

    context 'for an `updated_at` nil (new records)' do
      let(:updated_at) { nil }

      it 'returns true' do
        expect(subject.stale?).to eq(true)
      end
    end

    context 'for a stale court record' do
      context 'exact threshold' do
        let(:updated_at) { 72.hours.ago }

        it 'returns true' do
          expect(subject.stale?).to eq(true)
        end
      end

      # mutant kill
      context 'older than the threshold' do
        let(:updated_at) { 73.hours.ago }

        it 'returns true' do
          expect(subject.stale?).to eq(true)
        end
      end
    end

    context 'for an up to date court record' do
      let(:updated_at) { 1.day.ago }

      it 'returns false' do
        expect(subject.stale?).to eq(false)
      end
    end
  end
end
