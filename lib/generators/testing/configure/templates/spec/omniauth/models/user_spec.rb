describe User do

  before(:each) { @user = FactoryBot.create(:user) }

  subject { @user }

  it { should respond_to(:name) }

  it "#name returns a string" do
    expect(@user.name).to match 'Test User'
  end

end
