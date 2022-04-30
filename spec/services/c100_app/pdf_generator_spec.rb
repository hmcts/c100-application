require 'rails_helper'

RSpec.describe C100App::PdfGenerator do
  let(:wicked_pdf) { instance_double(WickedPdf) }
  let(:combiner)   { [] }

  before do
    allow(WickedPdf).to receive(:new).and_return(wicked_pdf)
    allow(CombinePDF).to receive(:new).and_return(combiner)
  end

  describe '#generate' do
    let(:c100_application) { double('c100_application') }

    let(:presenter) {
      double(
        'Presenter',
        name: 'Test',
        page_number: '[xx]/[yy]',
        template: 'path/to/template',
        raw_file_path: raw_file_path,
        c100_application: c100_application,
      )
    }
    let(:document)  { 'a form document' }
    let(:raw_file_path) { nil }

    before do
      allow(c100_application).to receive(:reference_code).and_return('12345/XYZ')
    end

    it 'renders a form using a presenter' do
      expect(ApplicationController).to receive(:render).with(
        template: 'path/to/template', locals: { presenter: presenter }
      ).and_return(document)

      expect(wicked_pdf).to receive(:pdf_from_string).with(
        document, { footer: { right: '12345/XYZ   Test   [xx]/[yy]' }, extra: '--enable-forms' }
      ).and_return(document)

      # Using 0 copies just to make this test scenario simpler to mock,
      # as we want to test here only the call to `pdf_from_presenter`
      subject.generate(presenter, copies: 0)
    end

    it 'generates a PDF document with N copies' do
      expect(subject).to receive(:pdf_from_presenter).with(presenter).and_return(document)
      expect(CombinePDF).to receive(:parse).twice.with(document).and_return(document)

      subject.generate(presenter, copies: 2)

      expect(combiner).to match_array([document, document])
    end

    context 'appends a raw document if there is one specified in the presenter' do
      let(:raw_file_path) { 'test/path.pdf' }

      it 'generates the PDF' do
        expect(subject).to receive(:pdf_from_presenter).with(presenter).and_return(document)
        expect(CombinePDF).to receive(:parse).with(document).and_return(document)
        expect(CombinePDF).to receive(:load).with('test/path.pdf').and_return(document)

        subject.generate(presenter, copies: 1)

        expect(combiner).to match_array([document, document])
      end
    end
  end

  describe '#to_pdf' do
    let(:combiner) { double('Combiner', forms_data: forms_data) }

    context 'there is data in the combiner' do
      let(:forms_data) { {whatever: 'xyz'} }

      it 'delegates to the combiner' do
        expect(combiner).to receive(:to_pdf)
        subject.to_pdf
      end
    end

    context 'there is no data yet in the combiner' do
      let(:forms_data) { nil }

      it 'returns an empty string without calling the combiner' do
        expect(combiner).not_to receive(:to_pdf)
        expect(subject.to_pdf).to eq('')
      end
    end
  end

  describe '#has_forms_data?' do
    let(:combiner) { double('Combiner', forms_data: forms_data) }

    context 'there is data in the combiner' do
      let(:forms_data) { {whatever: 'xyz'} }
      it { expect(subject.has_forms_data?).to eq(true) }
    end

    context 'there is no data yet in the combiner' do
      let(:forms_data) { nil }
      it { expect(subject.has_forms_data?).to eq(false) }
    end
  end
end
