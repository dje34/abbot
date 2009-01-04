require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

# The proxy helper defines proxy settings that can be used with sc-server
describe Abbot::Buildfile, 'proxy helper' do
  
  it "should save the opts for a new proxy" do
    b = Abbot::Buildfile.define do
      proxy '/url', :foo => :bar
    end
    b.proxies['/url'].foo.should eql(:bar)
  end

  it "should save the REPLACE opts for multiple calls to proxy" do
    b = Abbot::Buildfile.define do
      proxy '/url', :test1 => :foo, :test2 => :foo
      proxy '/url', :test1 => :bar
    end
    b.proxies['/url'].test1.should eql(:bar)
    b.proxies['/url'].test2.should be_nil
  end
  
  it "should merge multiple proxy urls and REPLACE opts for chained files" do
    a = Abbot::Buildfile.define do
      proxy '/url1', :test1 => :foo, :test2 => :foo
      proxy '/url2', :test1 => :foo
    end
    
    b = Abbot::Buildfile.define(a) do
      proxy '/url1', :test1 => :bar
    end
    
    b.proxies['/url1'].test1.should eql(:bar)
    b.proxies['/url1'].test2.should be_nil
    b.proxies['/url2'].test1.should eql(:foo)
  end
  
end

