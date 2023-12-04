require "rails_helper"

describe Password, type: :model do
  let(:check_password) { "orangeCurtainNeverMORE3022$$" }

  subject { described_class.new(password: check_password) }

  let(:errors_json) { subject.errors.to_json }

  describe "validations" do
    context "with a complex password" do
      let(:check_password) { "orangeCurtainNeverMORE3022$$" }
      it { is_expected.to be_valid }
    end

    context "with a password that is too simple" do
      let(:check_password) { "aaaAAA111$$$" }

      it { is_expected.to_not be_valid }

      it "contains the appropriate error" do
        subject.validate
        expect(errors_json).to match /Your password needs more entropy. Try adding another word/
      end
    end

    context "with a password that is too short" do
      let(:check_password) { "OrangeM$" }

      it { is_expected.to_not be_valid }

      it "contains the appropriate error" do
        subject.validate
        expect(errors_json).to match /at least twelve characters/
      end
    end

    context "with a password missing numbers" do
      let(:check_password) { "orangeCurtainNeverMORE____$$" }

      it { is_expected.to_not be_valid }

      it "contains the appropriate error" do
        subject.validate
        expect(errors_json).to match /contain a digit/
      end
    end

    context "when missing lowercase letters" do
      let(:check_password) { "ORANGECURTAINNEVERMORE3022$$" }

      it { is_expected.to_not be_valid }

      it "contains the appropriate error" do
        subject.validate
        expect(errors_json).to match /contain a lower case letter/
      end
    end

    context "when missing uppercase letters" do
      let(:check_password) { "orangecurtainnevermore3022$$" }

      it { is_expected.to_not be_valid }

      it "contains the appropriate error" do
        subject.validate
        expect(errors_json).to match /contain an upper case letter/
      end
    end

    context "when missing a symbol" do
      let(:check_password) { "orangeCurtainNeverMORE302200" }

      it { is_expected.to_not be_valid }

      it "contains the appropriate error" do
        subject.validate
        expect(errors_json).to match /contain a symbol/
      end
    end
  end
end
