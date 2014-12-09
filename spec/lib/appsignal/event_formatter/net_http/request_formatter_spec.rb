require 'spec_helper'

describe Appsignal::EventFormatter::NetHttp::RequestFormatter do
  let(:klass) { Appsignal::EventFormatter::NetHttp::RequestFormatter }
  let(:formatter) { klass.new }

  it "should register request.net_http" do
    Appsignal::EventFormatter.registered?('request.net_http', klass).should be_true
  end

  describe "#format" do
    let(:payload) { {:url => 'http://appsignal.com/about', :method => 'GET'} }
    subject { formatter.format(payload) }

    it { should == ['GET http://appsignal.com/about', nil] }
  end
end
