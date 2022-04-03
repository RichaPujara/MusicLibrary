require './main'
require './user'

describe "#create_user(user_list, user_file_name)" do
    let(:user_file_name) { "resources/test/user_list.csv" }
    let(:user_list) { CSV.parse(File.read(user_file_name), headers: true, skip_blanks: true) }

    before do
        allow(::Kernel).to receive(:system)
        allow_any_instance_of(Object).to receive(:sleep)
    end

    after(:all) do
        user_file_name = "resources/test/user_list.csv"
        File.delete(user_file_name)
        CSV.open(user_file_name, "a+", headers: true) do |csv|
            csv << ["first_name", "last_name", "username", "password", "path"]
        end
    end

    it "create a new user" do
        actual_stdout = $stdout
        $stdout = File.open(File::NULL, "w")
        allow($stdin).to receive(:gets).and_return('Jane', 'Doe', 'tester', 'pass', 'resources')
        expected_user = User.new('JANE', 'DOE', 'tester', 'pass', 'resources')
        actual_user = create_user(user_list, user_file_name)
        test_user(actual_user, expected_user)
        $stdout = actual_stdout
    end

    it "create a new user, after invalid username corrected" do
        actual_stdout = $stdout
        $stdout = File.open(File::NULL, "w")
        allow($stdin).to receive(:gets).and_return('Jane', 'Doe', 'tester', '1', 'tester2', 'pass', 'resources')
        expected_user = User.new('JANE', 'DOE', 'tester2', 'pass', 'resources')
        actual_user = create_user(user_list, user_file_name)
        test_user(actual_user, expected_user)
        $stdout = actual_stdout
    end

    it "create a new user, after invalid music library path corrected" do
        actual_stdout = $stdout
        $stdout = File.open(File::NULL, "w")
        allow($stdin).to receive(:gets).and_return('Jane', 'Doe', 'tester3', 'pass', 'specs', '1', 'resources')
        expected_user = User.new('JANE', 'DOE', 'tester3', 'pass', 'resources')
        actual_user = create_user(user_list, user_file_name)
        test_user(actual_user, expected_user)
        $stdout = actual_stdout
    end
end

describe "#login(user_list, user_file_name, uname, pword)" do
    let(:user_file_name) { "resources/test/user_list.csv" }
    let(:user_list) { CSV.parse(File.read(user_file_name), headers: true, skip_blanks: true) }
    let(:uname) { "tester" }
    let(:pword) { "pass" }
    let(:expected_user) { User.new('JANE', 'DOE', 'tester', 'pass', 'resources') }

    before do
        allow(::Kernel).to receive(:system)
        allow_any_instance_of(Object).to receive(:sleep)
    end

    after(:all) do
        user_file_name = "resources/test/user_list.csv"
        File.delete(user_file_name)
        CSV.open(user_file_name, "a+", headers: true) do |csv|
            csv << ["first_name", "last_name", "username", "password", "path"]
        end
    end

    it "login takes to create user when user list is empty" do
        actual_stdout = $stdout
        $stdout = File.open(File::NULL, "w")
        allow($stdin).to receive(:gets).and_return('Jane', 'Doe', 'tester', 'pass', 'resources')
        actual_user = login(user_list, user_file_name, uname, pword)
        test_user(actual_user, expected_user)
        $stdout = actual_stdout
    end

    it "login, after invalid username corrected" do
        actual_stdout = $stdout
        $stdout = File.open(File::NULL, "w")
        allow($stdin).to receive(:gets).and_return('1', uname)
        actual_user = login(user_list, user_file_name, 'unknown', pword)
        test_user(actual_user, expected_user)
        $stdout = actual_stdout
    end

    it "login, after invalid username takes to create new user" do
        actual_stdout = $stdout
        $stdout = File.open(File::NULL, "w")
        allow($stdin).to receive(:gets).and_return('2', 'Jane', 'Doe', 'tester2', 'pass', 'resources')
        actual_user = login(user_list, user_file_name, 'unknown', pword)
        new_user =  User.new('JANE', 'DOE', 'tester2', 'pass', 'resources')
        test_user(actual_user, new_user)
        $stdout = actual_stdout
    end

    it "login, after invalid password corrected" do
        actual_stdout = $stdout
        $stdout = File.open(File::NULL, "w")
        allow($stdin).to receive(:gets).and_return('1', pword)
        actual_user = login(user_list, user_file_name, uname, 'wrong')
        test_user(actual_user, expected_user)
        $stdout = actual_stdout
    end

    it "login, after invalid username takes to create new user" do
        actual_stdout = $stdout
        $stdout = File.open(File::NULL, "w")
        allow($stdin).to receive(:gets).and_return('2', 'Jane', 'Doe', 'tester3', 'pass', 'resources')
        actual_user = login(user_list, user_file_name, uname, 'wrong')
        new_user =  User.new('JANE', 'DOE', 'tester3', 'pass', 'resources')
        test_user(actual_user, new_user)
        $stdout = actual_stdout
    end
end

def test_user(actual_user, expected_user)
    expect(actual_user.name).to eq expected_user.name
    expect(actual_user.username).to eq expected_user.username
    expect(actual_user.password).to eq expected_user.password
    expect(actual_user.dir_location).to eq expected_user.dir_location
end
