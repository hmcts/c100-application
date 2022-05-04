require 'rails_helper'

RSpec.describe C100App::NavigationStack do
  subject { described_class.new(c100_application, request) }

  let(:c100_application) { C100Application.new(navigation_stack: navigation_stack) }
  let(:request) { double('Request', session: session, fullpath: '/dummy_step') }
  let(:session) { Hash.new } # a session behaves like a hash so for test purposes we use this

  let(:navigation_stack) { [] }

  before do
    allow(c100_application).to receive(:save!)
  end

  describe '#update!' do
    it 'does not `touch` timestamps on save' do
      expect(c100_application).to receive(:save!).with(touch: false)
      subject.update!
    end

    it 'sets the CYA origin flag to `false`' do
      expect(session).to receive(:[]=).with(:cya_origin, false)
      subject.update!
    end

    it 'does not need to check current path against the regexp list' do
      expect(Regexp).not_to receive(:union)
      subject.update!
    end

    context 'when the stack is empty' do
      let(:navigation_stack) { [] }

      it 'adds the page to the stack' do
        subject.update!
        expect(c100_application.navigation_stack).to eq(['/dummy_step'])
      end
    end

    context 'when the current page is on the stack' do
      let(:navigation_stack) { %w(/foo /bar /dummy_step /baz )}

      it 'rewinds the stack to the appropriate point' do
        subject.update!
        expect(c100_application.navigation_stack).to eq(%w(/foo /bar /dummy_step))
      end
    end

    context 'when the current page is not on the stack' do
      let(:navigation_stack) { %w(/foo /bar /baz) }

      it 'adds it to the end of the stack' do
        subject.update!
        expect(c100_application.navigation_stack).to eq(%w(/foo /bar /baz /dummy_step))
      end
    end

    context 'when coming from check your answers' do
      context 'for a complete funnel' do
        let(:navigation_stack) { %w(/foo /bar /dummy_step /steps/application/payment /steps/application/check_your_answers)}

        it 'sets the CYA origin flag to `true`' do
          expect(session).to receive(:[]=).with(:cya_origin, true)
          subject.update!
        end

        context 'and the target step can do fast forward' do
          before do
            allow(request).to receive(:fullpath).and_return('/steps/application/details')
          end

          it 'does not change the stack' do
            subject.update!
            expect(c100_application.navigation_stack).to eq(navigation_stack)
          end
        end

        context 'and the target step cannot do fast forward' do
          it 'changes the stack' do
            subject.update!
            expect(c100_application.navigation_stack).to eq(%w(/foo /bar /dummy_step))
          end
        end
      end

      context 'for an incomplete funnel' do
        let(:navigation_stack) { %w(/foo /bar /dummy_step /another_step /steps/application/check_your_answers)}

        it 'sets the CYA origin flag to `false`' do
          expect(session).to receive(:[]=).with(:cya_origin, false)
          subject.update!
        end

        it 'changes the stack' do
          subject.update!
          expect(c100_application.navigation_stack).to eq(%w(/foo /bar /dummy_step))
        end
      end
    end
  end
end
