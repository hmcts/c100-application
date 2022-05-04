require 'rails_helper'

class TestModel
  include ActiveModel::Validations

  def initialize(attributes = {})
    @attributes = attributes
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end
end

class TestUser < TestModel
  validates :email, email: true
end

class TestUserAllowsNil < TestModel
  validates :email, email: { allow_nil: true }
end

class TestUserAllowsNilFalse < TestModel
  validates :email, email: { allow_nil: false }
end

describe EmailValidator do
  describe 'COMMON_DOMAIN_TYPOS' do
    it 'has a small list of common email domain typos' do
      expect(
        described_class::COMMON_DOMAIN_TYPOS
      ).to eq(%w[
        cloud.com
        gamil.com
        gmial.com
        homail.com
      ])
    end
  end

  describe 'VALID_GMAIL_DOMAINS' do
    it 'valid gmail domains' do
      expect(
        described_class::VALID_GMAIL_DOMAINS
      ).to eq(%w[
        gmail.com
        googlemail.com
      ])
    end
  end

  describe 'VALID_HOTMAIL_DOMAINS' do
    it 'valid hotmail domains' do
      expect(
        described_class::VALID_HOTMAIL_DOMAINS
      ).to eq(%w[
        hotmail.com
        hotmail.co.uk
        hotmail.fr
        hotmail.it
        hotmail.es
        hotmail.de
      ])
    end
  end

  describe 'validation' do
    context 'given the valid emails' do
      [
        "a+b@plus-in-local.com",
        "a_b@underscore-in-local.com",
        "test@gmail.com",
        "test@googlemail.com",
        "test@hotmail.com",
        " user@example.com ",
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@letters-in-local.org",
        "01234567890@numbers-in-local.net",
        "a@single-character-in-local.org",
        "one-character-third-level@a.example.com",
        "single-character-in-sld@x.org",
        "local@dash-in-sld.com",
        "letters-in-sld@123.com",
        "one-letter-sld@x.org",
        "uncommon-tld@sld.museum",
        "uncommon-tld@sld.travel",
        "uncommon-tld@sld.mobi",
        "country-code-tld@sld.uk",
        "country-code-tld@sld.rw",
        "local@sld.newTLD",
        "local@sub.domains.com",
        "aaa@bbb.co.jp",
        "nigel.worthington@big.co.uk",
        "f@c.com",
        "areallylongnameaasdfasdfasdfasdf@asdfasdfasdfasdfasdf.ab.cd.ef.gh.co.ca",
        "ящик@яндекс.рф",
      ].each do |email|
        it "#{email.inspect} should be valid" do
          expect(TestUser.new(:email => email)).to be_valid
        end
      end
    end

    context 'given the invalid emails' do
      [
        "",
        "f@s",
        "f@s.c",
        "@bar.com",
        "test@example.com@example.com",
        "test@",
        "@missing-local.org",
        "a b@space-in-local.com",
        "! \#$%\`|@invalid-characters-in-local.org",
        "<>@[]\`|@even-more-invalid-characters-in-local.org",
        "missing-sld@.com",
        "invalid-characters-in-sld@! \"\#$%(),/;<>_[]\`|.org",
        "missing-dot-before-tld@com",
        "missing-tld@sld.",
        " ",
        "missing-at-sign.net",
        "unbracketed-IP@127.0.0.1",
        "invalid-ip@127.0.0.1.26",
        "another-invalid-ip@127.0.0.256",
        "IP-and-port@127.0.0.1:25",
        "the-local-part-is-invalid-if-it-is-longer-than-sixty-four-characters@sld.net",
        "user@example.com\n<script>alert('hello')</script>",
        "hans,peter@example.com",
        "hans(peter@example.com",
        "hans)peter@example.com",
        "partially.\"quoted\"@sld.com",
        "&'*+-./=?^_{}~@other-valid-characters-in-local.net",
        "mixed-1234-in-{+^}-local@sld.net",
      ].each do |email|
        it "#{email.inspect} should not be valid" do
          expect(TestUser.new(:email => email)).not_to be_valid
        end
      end
    end

    context 'given the silly email typos' do
      %w(
        test@cloud.com
        TEST@GMIAL.COM
        test@homail.com
      ).each do |email|
        it "#{email.inspect} should not be valid" do
          expect(TestUser.new(email: email)).not_to be_valid
        end
      end
    end

    context 'given typos for gmail and hotmail domains' do
      %w(
        test@hotmial.com
        test@hotmail.couk
        TEST@GOOGLE.COM
        test@gmail.co.uk
      ).each do |email|
        it "#{email.inspect} should not be valid" do
          expect(TestUser.new(email: email)).not_to be_valid
        end
      end
    end
  end

  describe 'nil email' do
    it 'should not be valid when `allow_nil` option is missing' do
      expect(TestUser.new(email: nil)).not_to be_valid
    end

    it 'should be valid when `allow_nil` option is set to true' do
      expect(TestUserAllowsNil.new(email: nil)).to be_valid
    end

    it 'should not be valid when `allow_nil` option is set to false' do
      expect(TestUserAllowsNilFalse.new(email: nil)).not_to be_valid
    end
  end
end
