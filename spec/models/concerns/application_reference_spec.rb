require 'rails_helper'

RSpec.describe ApplicationReference do
  let(:test_class) { C100Application }

  subject { test_class.new(id: 'db2ed4fd-b1d1-405b-ade6-4c1405512e9d', created_at: Date.new(2018, 5, 20)) }

  context '#reference_code' do
    it { expect(subject.reference_code).to eq('2018/05/DB2ED4FD') }
  end

  context '.find_by_reference_code' do
    let(:date_finder_double) { double('date_finder_double').as_null_object }
    let(:uuid_finder_double) { double('uuid_finder_double').as_null_object }

    it 'has the correct date filter criteria' do
      expect(test_class).to receive(:where).with(
        created_at: [Date.new(2018, 5, 1).beginning_of_day..Date.new(2018, 5, 31).end_of_day]
      ).and_return(date_finder_double)

      test_class.find_by_reference_code('2018/05/DB2ED4FD')
    end

    it 'has the correct uuid filter criteria' do
      expect(test_class).to receive(:where).and_return(date_finder_double)

      expect(date_finder_double).to receive(:where).with(
        "id::text ILIKE :uuid_filter", uuid_filter: 'DB2ED4FD-%'
      ).and_return(uuid_finder_double)

      test_class.find_by_reference_code('2018/05/DB2ED4FD')
    end
  end
end
