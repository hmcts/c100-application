require 'spec_helper'

RSpec.describe PetitionPresenter do
  subject { described_class.new(c100_application) }

  let(:c100_application) {
    instance_double(C100Application, orders: orders, orders_additional_details: orders_additional_details)
  }

  let(:orders) { PetitionOrder.string_values }
  let(:orders_additional_details) { 'details' }

  describe '#child_arrangements_orders' do
    it 'only returns the orders set to true' do
      expect(subject.child_arrangements_orders).to eq(%w(
        child_arrangements_home
        child_arrangements_time
      ))
    end
  end

  describe '#prohibited_steps_orders' do
    it 'only returns the orders set to true' do
      expect(subject.prohibited_steps_orders).to eq(%w(
        prohibited_steps_names
        prohibited_steps_medical
        prohibited_steps_holiday
        prohibited_steps_moving
        prohibited_steps_moving_abroad
      ))
    end
  end

  describe '#specific_issues_orders' do
    it 'only returns the orders set to true' do
      expect(subject.specific_issues_orders).to eq(%w(
        specific_issues_holiday
        specific_issues_school
        specific_issues_religion
        specific_issues_names
        specific_issues_medical
        specific_issues_moving
        specific_issues_moving_abroad
        specific_issues_child_return
      ))
    end
  end

  describe '#formalise_arrangements' do
    it 'only returns the orders set to true' do
      expect(subject.formalise_arrangements).to eq(%w(
        consent_order
      ))
    end
  end

  describe '#all_selected_orders' do
    it 'only returns the orders set to true' do
      expect(subject.all_selected_orders).to eq(%w(
        child_arrangements_home
        child_arrangements_time
        prohibited_steps_names
        prohibited_steps_medical
        prohibited_steps_holiday
        prohibited_steps_moving
        prohibited_steps_moving_abroad
        specific_issues_holiday
        specific_issues_school
        specific_issues_religion
        specific_issues_names
        specific_issues_medical
        specific_issues_moving
        specific_issues_moving_abroad
        specific_issues_child_return
        consent_order
        other_issue
      ))
    end

    context 'filter `group_xxx` values' do
      let(:orders) {
        %w(
          group_prohibited_steps
          prohibited_steps_moving_abroad
          group_specific_issues
          specific_issues_religion
        )
      }

      it {
        expect(
          subject.all_selected_orders
        ).to eq(%w(
          prohibited_steps_moving_abroad
          specific_issues_religion
        ))
      }
    end
  end

  describe 'Other issue' do
    context 'when there is `other` issue' do
      let(:orders) { ['other_issue'] }
      let(:orders_additional_details) { 'details' }

      it { expect(subject.other_issue?).to eq(true) }
      it { expect(subject.other_issue_details).to eq('details') }
    end

    context 'when there is no `other` issue' do
      let(:orders) { ['prohibited_steps_moving'] }
      let(:orders_additional_details) { nil }

      it { expect(subject.other_issue?).to eq(false) }
      it { expect(subject.other_issue_details).to eq(nil) }
    end
  end

  describe '#count_for' do
    context 'for a single group' do
      let(:orders) { ['child_arrangements_home'] }
      let(:count)  { subject.count_for(:child_arrangements_orders) }

      it { expect(count).to eq(1) }
    end

    context 'for multiple groups' do
      let(:orders) {%w(child_arrangements_home specific_issues_religion)}
      let(:count)  { subject.count_for(:child_arrangements_orders, :specific_issues_orders) }

      it { expect(count).to eq(2) }
    end
  end
end
