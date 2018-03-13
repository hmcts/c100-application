require 'rails_helper'

describe Court do
  describe '#initialize' do
    let(:court){ Court.new(params) }
    context 'given a hash of key/value pairs' do
      let(:params){
        {name: 'my court', slug: 'my slug'}
      }

      it 'sets the values which match a Courts attributes' do
        expect(court.name).to eq(params[:name])
        expect(court.slug).to eq(params[:slug])
      end

      context 'containing a key which does not match a Court attribute' do
        let(:params){
          {name: 'my court', foo: 'bar'}
        }
        it 'does not get set' do
          expect(court.send(:instance_variable_get, '@foo')).to be_nil
        end
      end
    end

    context 'given no args' do
      let(:court){ Court.new }
      it 'returns a valid Court' do
        expect(court).to be_a(Court)
      end
    end
  end

  describe '#from_courtfinder_data!' do
    before do
      allow(court).to receive(:merge_from_full_json_dump!)
    end
    context 'given a hash' do
      let(:args){
        {}
      }
      let(:court){ Court.new }

      it 'calls parse_basic_attributes! with the given hash' do
        expect(court).to receive(:parse_basic_attributes!).with(args)
        court.from_courtfinder_data!(args)
      end

      it 'returns itself' do
        expect(court.from_courtfinder_data!(args)).to eq(court)
      end

      context 'including an address key' do
        let(:args){
          {'address' => 'my address'}
        }

        it 'calls parse_given_address! with the address value' do
          expect(court).to receive(:parse_given_address!).with('my address')
          court.from_courtfinder_data!(args)
        end
      end
    end
  end

  describe '#parse_basic_attributes!' do
    context 'given a hash' do
      let(:args){ {} }
      let(:court){ Court.new }
      before do
        court.parse_basic_attributes!(args)
      end

      context 'including name' do
        let(:args){ {'name' => 'my name'} }

        it 'sets the name attribute' do
          expect(court.name).to eq('my name')
        end
      end
      context 'including slug' do
        let(:args){ {'slug' => 'my slug'} }

        it 'sets the slug attribute' do
          expect(court.slug).to eq('my slug')
        end
      end

      context 'including number' do
        let(:args){ {'number' => 'my number'} }

        it 'sets the phone_number attribute' do
          expect(court.phone_number).to eq('my number')
        end
      end
    end
  end

  describe '#parse_given_address!' do
    context 'given a hash' do
      let(:args){ {} }
      let(:court){ Court.new }
      before do
        court.parse_given_address!(args)
      end

      context 'including address_lines' do
        let(:args){ {'address_lines' => 'my address_lines'} }

        it 'sets the address_lines attribute' do
          expect(court.address_lines).to eq('my address_lines')
        end
      end
      context 'including town' do
        let(:args){ {'town' => 'my town'} }

        it 'sets the town attribute' do
          expect(court.town).to eq('my town')
        end
      end

      context 'including postcode' do
        let(:args){ {'postcode' => 'my postcode'} }

        it 'sets the postcode attribute' do
          expect(court.postcode).to eq('my postcode')
        end
      end
    end
  end

  describe '#address' do
    subject{
      Court.new(address_lines: address_lines, town: 'town', postcode: 'postcode')
    }
    let(:address_lines){ ['line 1', 'line 2'] }

    it 'returns a flattened array of address_lines, town and postcode' do
      expect(subject.address).to eq(['line 1', 'line 2', 'town', 'postcode'])
    end

    context 'when any lines are duplicated' do
      let(:address_lines){ ['line 1', 'postcode'] }

      it 'removes the duplicates' do
        expect(subject.address).to eq(['line 1', 'postcode', 'town'])
      end
    end

    context 'when any lines are blank' do
      let(:address_lines){ ['line 1', ''] }

      it 'removes the blank lines' do
        expect(subject.address).to eq(['line 1', 'town', 'postcode'])
      end
    end
  end

  describe '.all' do
    let(:courts){ [] }
    before do
      allow_any_instance_of(C100App::CourtfinderAPI).to receive(:all).and_return(courts)
    end

    it 'calls all on the CourtfinderAPI' do
      expect_any_instance_of(C100App::CourtfinderAPI).to receive(:all)
      Court.all
    end

    it 'returns the CourtfinderAPI result' do
      expect(Court.all).to eq(courts)
    end

    context 'given a :cache_ttl' do
      it 'passes it to the CourtfinderAPI call' do
        expect_any_instance_of(C100App::CourtfinderAPI).to receive(:all).with(cache_ttl: 1234)
        Court.all(cache_ttl: 1234)
      end
    end
    context 'given no :cache_ttl' do
      it 'passes 86400 to the CourtfinderAPI call' do
        expect_any_instance_of(C100App::CourtfinderAPI).to receive(:all).with(cache_ttl: 86400)
        Court.all
      end
    end
  end

  describe '#merge_from_full_json_dump!' do
    let(:emails){
      [
        {
          'description' => 'Enquiries',
          'address' => 'my@email',
        },
      ]
    }
    let(:courts){
      [
        { 'slug' => 'my-slug',
          'emails' => emails,
          'opening_times' => [
            {
              'sort' => 0,
              'opening_time' => '9:00-5pm'
            }
          ]
        }
      ]
    }
    before do
      allow(Court).to receive(:all).and_return(courts)
    end

    it 'gets all Courts' do
      expect(Court).to receive(:all).and_return(courts)
      subject.send(:merge_from_full_json_dump!)
    end

    context 'when the all-courts data includes a Court with a matching slug' do
      before do
        subject.slug = 'my-slug'
        allow(subject).to receive(:best_enquiries_email).with(emails).and_return( 'test@email' )

      end

      it 'sets opening_times to the opening_time keys from the court data' do
        subject.send(:merge_from_full_json_dump!)
        expect(subject.opening_times).to eq(['9:00-5pm'])
      end

      it 'gets the best_enquiries_email' do
        expect(subject).to receive(:best_enquiries_email).with(emails).and_return( 'test@email' )
        subject.send(:merge_from_full_json_dump!)
      end

      it 'sets email to the best_enquiries_email' do
        subject.send(:merge_from_full_json_dump!)
        expect(subject.email).to eq('test@email')
      end
    end
  end

  describe '#best_enquiries_email' do
    context 'given an array of email hashes' do
      let(:emails){
        [
          {
            'description' => 'Enquiries',
            'address' => 'my@email',
          },
        ]
      }

      context 'containing a nil entry' do
        let(:emails){
          [
            nil,
            {
              'description' => 'Enquiries',
              'address' => 'my@email',
            }
          ]
        }

        it 'returns the enquiries email' do
          expect(subject.send(:best_enquiries_email, emails)).to eq('my@email')
        end
      end
      context 'containing an email with description matching "children"' do
        let(:emails){
          [
            {
              'description' => 'Enquiries',
              'address' => 'my@email',
            },
            {
              'description' => 'All children enquiries',
              'address' => 'children@email'
            }
          ]
        }

        it 'returns the email address of the matching description' do
          expect(subject.send(:best_enquiries_email, emails)).to eq('children@email')
        end

        context 'and containing an email with description matching "family"' do
          let(:emails){
            [
              {
                'description' => 'All children enquiries',
                'address' => 'children@email'
              },
              {
                'description' => 'All family enquiries',
                'address' => 'family@email'
              }
            ]
          }
          it 'returns the email address of the description matching children' do
            expect(subject.send(:best_enquiries_email, emails)).to eq('children@email')
          end
        end
      end

      context 'containing an email with description matching "family"' do
        let(:emails){
          [
            {
              'description' => 'Enquiries',
              'address' => 'my@email',
            },
            {
              'description' => 'All family enquiries',
              'address' => 'family@email'
            }
          ]
        }

        it 'returns the email address of the matching description' do
          expect(subject.send(:best_enquiries_email, emails)).to eq('family@email')
        end

        context 'and containing an email with description matching "enquiries"' do
          let(:emails){
            [
              {
                'description' => 'Enquiries',
                'address' => 'my@email',
              },
              {
                'description' => 'All family things',
                'address' => 'family@email'
              }
            ]
          }

          it 'returns the email address of the description matching family' do
            expect(subject.send(:best_enquiries_email, emails)).to eq('family@email')
          end
        end
      end

      context 'containing an email with description matching "enquiries"' do
        let(:emails){
          [
            {
              'description' => 'All other things',
              'address' => 'other@email'
            },
            {
              'description' => 'Enquiries',
              'address' => 'my@email',
            },
          ]
        }

        it 'returns the email address of the matching description' do
          expect(subject.send(:best_enquiries_email, emails)).to eq('my@email')
        end
      end

      context 'that is empty' do
        let(:emails){ [] }
        it 'returns nil' do
          expect(subject.send(:best_enquiries_email, emails)).to eq(nil)
        end
      end
      context 'that is not empty but matches no other criterion' do
        let(:emails){
          [
            {
              'description' => 'Should not match anything',
              'address' => 'my@email',
            },
          ]
        }
        it 'returns the first email' do
          expect(subject.send(:best_enquiries_email, emails)).to eq('my@email')
        end
      end
    end
  end
end
