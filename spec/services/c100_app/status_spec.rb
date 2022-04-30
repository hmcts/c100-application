require 'rails_helper'

RSpec.describe C100App::Status do
  describe '#success?' do
    before do
      allow(subject).to receive(:results).and_return(results)
    end

    context 'when all checks are OK' do
      let(:results) { {database: true, foobar: true, sidekiq: true} }
      it { expect(subject.success?).to eq(true) }
    end

    context 'when at least one check is KO' do
      let(:results) { {database: true, foobar: false, sidekiq: true} }
      it { expect(subject.success?).to eq(false) }
    end
  end

  describe '#response' do
    let(:database_active) { true }
    let(:sidekiq_queues) { [double(latency: 5), double(latency: 10)] }
    let(:sidekiq_process_set) { [1] }

    before do
      allow(ActiveRecord::Base.connection).to receive(:active?).and_return(database_active)
      allow(Sidekiq::Queue).to receive(:all).and_return(sidekiq_queues)
      allow(Sidekiq::ProcessSet).to receive(:new).and_return(sidekiq_process_set)
    end

    describe 'database' do
      context 'database is OK' do
        let(:database_active) { true }

        it {
          expect(subject.response[:dependencies]).to include('database' => true)
        }
      end

      context 'database is KO' do
        let(:database_active) { false }

        it {
          expect(subject.response[:dependencies]).to include('database' => false)
        }
      end

      context 'database is KO (raises error)' do
        before do
          allow(ActiveRecord::Base.connection).to receive(:active?).and_raise('boom')
        end

        it {
          expect(subject.response[:dependencies]).to include('database' => false)
        }
      end
    end

    describe 'sidekiq' do
      context 'sidekiq is OK' do
        let(:sidekiq_process_set) { [1] }

        it {
          expect(subject.response[:dependencies]).to include('sidekiq' => true)
        }
      end

      context 'sidekiq is KO' do
        let(:sidekiq_process_set) { [] }

        it {
          expect(subject.response[:dependencies]).to include('sidekiq' => false)
        }
      end

      context 'sidekiq is KO (raises error)' do
        before do
          allow(Sidekiq::ProcessSet).to receive(:new).and_raise('boom')
        end

        it {
          expect(subject.response[:dependencies]).to include('sidekiq' => false)
        }
      end
    end

    describe 'sidekiq_latency' do
      context 'returns the sum of the queues latencies' do
        it {
          expect(subject.response).to include(healthy: true)
          expect(subject.response[:dependencies]).to include('sidekiq_latency' => 15)
        }
      end

      context 'sidekiq is KO and queues method raises error' do
        before do
          allow(Sidekiq::Queue).to receive(:all).and_raise('boom')
        end

        it {
          expect(subject.response).to include('healthy': false)
          expect(subject.response[:dependencies]).to include('sidekiq_latency' => false)
        }
      end
    end
  end
end
