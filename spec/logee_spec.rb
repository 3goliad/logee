RSpec.describe Logee do
  it "has a version number" do
    expect(Logee::VERSION).not_to be nil
  end

  describe Logee::Logger do
    describe ".msg" do
      let(:target) { StringIO.new }
      subject { Logee::Logger.new(name: "subject", target: target) }
      it "logs a json message to the target" do
        expect { subject.msg("hi!") }.not_to raise_error
        expect { JSON.parse(target.string) }.not_to raise_error
        msg = JSON.parse(target.string)
        expect(msg["msg"]).to eq "hi!"
      end

      it "logs the logger name" do
        subject.msg("hi!")
        msg = JSON.parse(target.string)
        expect(msg["name"]).to eq "subject"
      end

      it "logs a time" do
        subject.msg("hi!")
        msg = JSON.parse(target.string)
        expect { Time.iso8601(msg["time"]) }.not_to raise_error
      end

      it "logs the hostname" do
        subject.msg("hi!")
        msg = JSON.parse(target.string)
        expect(msg["hostname"]).to eq `hostname`.strip
      end
    end
  end
end
