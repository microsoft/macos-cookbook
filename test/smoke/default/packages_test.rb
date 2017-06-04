describe package('homebrew') do
  it { should be_installed }
end

describe package('python3') do
  it { should be_installed }
end

describe package('mono') do
  it { should be_installed }
end

describe package('ifuse') do
  it { should be_installed }
end
