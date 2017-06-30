RSpec.describe "Authentication" do
  let(:password) { "8fe13E{50e" }
  let(:user) { create(:user, password: password) }

  describe "Logging in" do
    scenario "Logging in with correct credentials" do
      log_in
      expect(page).to have_current_path albums_path
    end

    scenario "Logging in with incorrect credentials" do
      log_in(password: "")
      expect(page).to have_current_path login_path
      expect(page).to have_content "Incorrect username or password"
    end
  end

  describe "Root path redirect" do
    scenario "When not logged in, root path redirects to login path" do
      visit '/'
      expect(page).to have_current_path login_path
    end
    scenario "When logged in, root path redirects to albums path" do
      log_in
      visit '/'
      expect(page).to have_current_path albums_path
    end
  end


  def log_in(username: nil, password: nil)
    visit login_path
    within '#login-box' do
      fill_in 'Username', with: username || user.username
      fill_in 'Password', with: password || self.password
    end
    click_button 'Log in'
  end

end