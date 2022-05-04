require 'rails_helper'

RSpec.describe PetitionOrder do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        child_arrangements_home
        child_arrangements_time
        group_prohibited_steps
        prohibited_steps_names
        prohibited_steps_medical
        prohibited_steps_holiday
        prohibited_steps_moving
        prohibited_steps_moving_abroad
        group_specific_issues
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
  end

  describe 'CHILD_ARRANGEMENTS' do
    it 'returns the expected values' do
      expect(described_class::CHILD_ARRANGEMENTS.map(&:to_s)).to eq(%w(
        child_arrangements_home
        child_arrangements_time
      ))
    end
  end

  describe 'CHILD_ARRANGEMENTS_HOME' do
    it 'returns the expected values' do
      expect(described_class::CHILD_ARRANGEMENTS_HOME.to_s).to eq('child_arrangements_home')
    end
  end

  describe 'CHILD_ARRANGEMENTS_TIME' do
    it 'returns the expected values' do
      expect(described_class::CHILD_ARRANGEMENTS_TIME.to_s).to eq('child_arrangements_time')
    end
  end

  describe 'PROHIBITED_STEPS' do
    it 'returns the expected values' do
      expect(described_class::PROHIBITED_STEPS.map(&:to_s)).to eq(%w(
        prohibited_steps_names
        prohibited_steps_medical
        prohibited_steps_holiday
        prohibited_steps_moving
        prohibited_steps_moving_abroad
      ))
    end
  end

  describe 'SPECIFIC_ISSUES' do
    it 'returns the expected values' do
      expect(described_class::SPECIFIC_ISSUES.map(&:to_s)).to eq(%w(
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

  describe 'FORMALISE_ARRANGEMENTS' do
    it 'returns the expected values' do
      expect(described_class::FORMALISE_ARRANGEMENTS.map(&:to_s)).to eq(%w(
        consent_order
      ))
    end
  end

  describe 'OTHER_ISSUE' do
    it 'returns the expected values' do
      expect(described_class::OTHER_ISSUE.to_s).to eq('other_issue')
    end
  end

  describe '.type_for' do
    context 'given a sub_type' do
      context 'starting with child_arrangements_' do
        it 'returns "child_arrangements"' do
          expect(described_class.type_for('child_arrangements_foo')).to eq("child_arrangements")
        end
      end

      context 'starting with prohibited_steps_' do
        it 'returns "prohibited_steps"' do
          expect(described_class.type_for('prohibited_steps_foo')).to eq("prohibited_steps")
        end
      end

      context 'starting with specific_issues_' do
        it 'returns "specific_issues"' do
          expect(described_class.type_for('specific_issues_foo')).to eq("specific_issues")
        end
      end

      context 'exactly matching consent order' do
        it 'returns "consent_order"' do
          expect(described_class.type_for('consent_order')).to eq("consent_order")
        end
      end

      context 'starting with anything else' do
        it 'returns "other_issue"' do
          expect(described_class.type_for('foo')).to eq("other_issue")
        end
      end
    end
  end
end
