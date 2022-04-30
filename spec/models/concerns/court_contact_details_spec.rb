require 'rails_helper'

RSpec.describe CourtContactDetails do
  let(:test_class) { Court }

  subject {
    test_class.new(
      id: 'court-slug',
      name: 'Court name',
      email: 'court@example',
      address: address,
    )
  }

  let(:address) { 'address' }

  describe 'Centralised courts (smoke test)' do
    it 'returns the list of slugs taking part in the centralisation' do
      expect(
        subject.send(:centralised_slugs)
      ).to match_array(%w(
        brighton-county-court
        chelmsford-county-and-family-court
        leeds-combined-court-centre
        medway-county-court-and-family-court
        west-london-family-court
        manchester-civil-justice-centre-civil-and-family-courts
        slough-county-court-and-family-court
        norwich-combined-court-centre
        milton-keynes-county-court-and-family-court
        milton-keynes-magistrates-court-and-family-court
        peterborough-combined-court-centre
        staines-county-court-and-family-court
        watford-county-court-and-family-court
        guildford-county-court-and-family-court
        reading-county-court-and-family-court
        oxford-combined-court-centre
        oxford-and-southern-oxfordshire-magistrates-court
        luton-justice-centre
        carlisle-combined-court
        carlisle-magistrates-court
        barrow-in-furness-county-court-and-family-court
        preston-crown-court-and-family-court-sessions-house
        central-family-court
        kingston-upon-hull-combined-court-centre
        newcastle-civil-family-courts-and-tribunals-centre
        sheffield-combined-court-centre
        teesside-combined-court-centre
        middlesbrough-county-court-at-teesside-combined-court
        york-county-court-and-family-court
        birmingham-civil-and-family-justice-centre
        coventry-combined-court-centre
        derby-combined-court-centre
        dudley-county-court-and-family-court
        east-london-family-court
        leicester-county-court-and-family-court
        lincoln-county-court-and-family-court
        northampton-crown-county-and-family-court
        nottingham-county-court-and-family-court
        stoke-on-trent-combined-court
        wolverhampton-combined-court-centre
        worcester-combined-court
        clerkenwell-and-shoreditch-county-court-and-family-court
        barnstaple-magistrates-county-and-family-court
        basingstoke-county-court-and-family-court
        bournemouth-and-poole-county-court-and-family-court
        bristol-civil-and-family-justice-centre
        exeter-combined-court-centre
        exeter-law-courts
        gloucester-and-cheltenham-county-and-family-court
        plymouth-combined-court
        portsmouth-combined-court-centre
        southampton-combined-court-centre
        swindon-combined-court
        taunton-crown-county-and-family-court
        torquay-and-newton-abbot-county-court-and-family-court
        truro-county-court-and-family-court
        yeovil-county-family-and-magistrates-court
        liverpool-civil-and-family-court
        weymouth-combined-court
        isle-of-wight-combined-court
        northampton-magistrates-court
        caernarfon-justice-centre
        caernarfon--justice-centre
        cardiff-civil-and-family-justice-centre
        carmarthen-county-court-and-family-court
        haverfordwest-county-court-and-family-court
        newport-south-wales-county-court-and-family-court
        swansea-civil-justice-centre
        wrexham-county-and-family-court
        wrexham-county-and-family--court
        bedford-county-court-and-family-court
        canterbury-combined-court-centre
        hertford-county-court-and-family-court
        high-wycombe-magistrates-court-and-family-court
      ))
    end
  end

  describe '#centralised?' do
    before do
      allow(subject).to receive(:slug).and_return(slug)
    end

    context 'for a centralised court' do
      let(:slug) { 'west-london-family-court' }

      it 'returns true' do
        expect(subject.centralised?).to eq(true)
      end
    end
  end

  describe '#url' do
    it 'returns the URL to the court in FaCT' do
      expect(subject.url).to eq('https://www.find-court-tribunal.service.gov.uk/courts/court-slug')
    end
  end

  describe '#full_address' do
    let(:address) { { 'address_lines' => address_lines, 'town' => 'town', 'postcode' => 'postcode' } }
    let(:address_lines){ ['line 1', 'line 2'] }

    before do
      allow(subject).to receive(:centralised?).and_return(centralised)
    end

    context 'for a centralised court' do
      let(:centralised) { true }

      it 'returns the central hub postal address' do
        expect(
          subject.full_address
        ).to eq(['C100 Applications', 'PO Box 1792', 'Southampton', 'SO15 9GG', 'DX: 135986 Southampton 32'])
      end
    end

    context 'for a not yet centralised court' do
      let(:centralised) { false }

      it 'returns a flattened array of name, address_lines, town and postcode' do
        expect(subject.full_address).to eq(['Court name', 'line 1', 'line 2', 'town', 'postcode'])
      end

      context 'when any lines are duplicated' do
        let(:address_lines){ ['Court name', 'postcode'] }

        it 'removes the duplicates' do
          expect(subject.full_address).to eq(['Court name', 'postcode', 'town'])
        end
      end

      context 'when any lines are blank' do
        let(:address_lines){ ['line 1', ''] }

        it 'removes the blank lines' do
          expect(subject.full_address).to eq(['Court name', 'line 1', 'town', 'postcode'])
        end
      end
    end
  end

  describe '#documents_email' do
    before do
      allow(subject).to receive(:centralised?).and_return(centralised)
    end

    context 'for a centralised court' do
      let(:centralised) { true }

      it 'returns the central hub email address' do
        expect(subject.documents_email).to eq('C100applications@justice.gov.uk')
      end
    end

    context 'for a not yet centralised court' do
      let(:centralised) { false }

      it 'returns the email address of the court' do
        expect(subject.documents_email).to eq('court@example')
      end
    end
  end
end
