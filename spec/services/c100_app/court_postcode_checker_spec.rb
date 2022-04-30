require 'rails_helper'

describe C100App::CourtPostcodeChecker do
  describe '#court_slugs_blocklist' do
    it 'returns the blocklisted slugs' do
      expect(
        subject.court_slugs_blocklist
      ).to match_array(%w[blocklisted-slug-example])
    end
  end

  describe '#court_for' do
    let(:dummy_court_objects) do
      { "courts" => [{"slug" => "dummy-court-slug"}] }
    end

    context 'when the CourtfinderAPI does not throw an error' do
      before do
        expect_any_instance_of(C100App::CourtfinderAPI).to receive(:court_for).once.with(
          described_class::AREA_OF_LAW, 'mypostcode'
        ).and_return(dummy_court_objects)

        expect(subject).to receive(:choose_from).with(
          dummy_court_objects['courts']
        ).and_return(candidate_court)
      end

      context 'and a candidate court was found' do
        before do
          expect_any_instance_of(C100App::CourtfinderAPI).to receive(:court_lookup).once.with(
            'dummy-court-slug'
          ).and_return('choosen court')
        end

        let(:candidate_court) { {"slug" => "dummy-court-slug"} }
        let(:choosen_court) { 'choosen court' }
        let(:court) { instance_double(Court) }

        it 'returns a Court instance' do
          expect(Court).to receive(:create_or_refresh).with(choosen_court).and_return(court)
          expect(subject.send(:court_for, 'mypostcode')).to eq(court)
        end
      end

      context 'and a candidate court was not found' do
        before do
          expect_any_instance_of(C100App::CourtfinderAPI).not_to receive(:court_lookup)
        end
        let(:candidate_court) { nil }

        it 'returns nil' do
          expect(Court).not_to receive(:create_or_refresh)
          expect(subject.send(:court_for, 'mypostcode')).to be_nil
        end
      end
    end

    context 'when the CourtfinderAPI throws an error' do
      before do
        allow_any_instance_of(C100App::CourtfinderAPI).to receive(:court_for).and_raise(StandardError)
      end

      it 'allows the error to propagate out un-caught' do
        expect { subject.send(:court_for, 'blah') }.to raise_error
      end
    end
  end

  describe '#choose_from' do
    let(:result) { subject.send(:choose_from, arg) }

    context 'given an array of hashes' do
      context 'with at least one hash that has a :slug key' do
        context 'when the first slug is not blocklisted' do
          let(:arg) do
            [
              {key: 'value'},
              {slug: 'a-valid-slug'},
              {slug: 'another-slug'},
            ]
          end

          it 'returns the hash' do
            expect(result).to eq({slug: 'a-valid-slug'})
          end
        end

        context 'when the first slug is blocklisted' do
          let(:arg) do
            [
              {key: 'value'},
              {slug: 'blocklisted-slug-example'},
              {slug: 'another-slug'},
            ]
          end
          it 'returns nil' do
            expect(result).to eq(nil)
          end
        end
      end

      context 'with no hash that has a :slug key, but at least one that has a "slug" key' do
        context 'when the first slug is not blocklisted' do
          let(:arg) do
            [
              {key: 'value'},
              {'slug' => 'a-valid-slug'},
              {'slug' => 'another-slug'},
            ]
          end

          it 'returns the hash' do
            expect(result).to eq({'slug' => 'a-valid-slug'})
          end
        end

        context 'when the first slug is blocklisted' do
          let(:arg) do
            [
              {key: 'value'},
              {'slug' => 'blocklisted-slug-example'},
              {'slug' => 'another-slug'},
            ]
          end

          it 'returns nil' do
            expect(result).to eq(nil)
          end
        end
      end
    end
  end
end
