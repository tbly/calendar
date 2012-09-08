require "spec_helper"

describe Notifier do
  before do
    @user = FactoryGirl.create( :user )
  end
  
  describe "reset_password" do
    let(:mail) { Notifier.reset_password }

    it "renders the headers" do
      mail.subject.should eq("Reset password")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "activation_needed_email" do
    let(:mail) { Notifier.activation_needed_email( @user ) }

    it "renders the headers" do
      mail.subject.should eq("Activation needed email")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "activation_success_email" do
    let(:mail) { Notifier.activation_success_email( @user ) }

    it "renders the headers" do
      mail.subject.should eq("Activation success email")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end
end
