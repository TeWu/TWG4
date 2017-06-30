
RSpec.describe User do

  describe ".authenticate" do
    let(:password) { "ac4^9Gc45Ga-9.3gde" }
    let(:user) { create(:user, password: password) }

    context "when passed credentials are correct" do
      it "returns correct User instance" do
        expect(User.authenticate(user.username, password)).to eq user
      end
    end

    context "when passed credentials are incorrect" do
      it "returns nil" do
        expect(User.authenticate(user.username, "a")).to be_nil
      end
    end
  end

end