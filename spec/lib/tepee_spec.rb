require 'spec_helper'
require 'tepee'
describe Tepee do
  # a value with a corresponding override in env
  VALUE1_VALUE = 'value1:' + SecureRandom.uuid
  ENV['VALUE123456789'] = VALUE1_VALUE

  # a value not overriden
  VALUE2_VALUE = 'value2:' + SecureRandom.uuid

  # a value with a corresponding override in env
  S1_VALUE1_VALUE = 's1value1:' + SecureRandom.uuid
  ENV['SECTION1_VALUE1'] = S1_VALUE1_VALUE

  # a value not overriden
  S1_VALUE2_VALUE = 's1value2:' + SecureRandom.uuid

  # a value with a corresponding override in env
  S2_VALUE1_VALUE = 's2value1:' + SecureRandom.uuid
  ENV['SECTION1_SECTION2_VALUE1'] = S2_VALUE1_VALUE

  # a value not overriden
  S2_VALUE2_VALUE = 's2value2:' + SecureRandom.uuid

  class DummyConf < Tepee
    add :value123456789, 'value should be overriden, you should not see this'
    add :value987654321, VALUE2_VALUE
    section(:section1) do
      add :value1, 'value should be overriden, you should not see this'
      add :value2, S1_VALUE2_VALUE
      section(:section2) do
        add :value1, 'value should be overriden, you should not see this'
        add :value2, S2_VALUE2_VALUE
      end
    end
  end

  # At root
  it { expect(DummyConf.value123456789).to eq VALUE1_VALUE }
  it { expect(DummyConf::VALUE123456789).to eq VALUE1_VALUE }
  it { expect(DummyConf.value987654321).to eq VALUE2_VALUE }
  it { expect(DummyConf::VALUE987654321).to eq VALUE2_VALUE }

  # In section 1
  it { expect(DummyConf.section1.value1).to eq S1_VALUE1_VALUE }
  it { expect(DummyConf.section1::VALUE1).to eq S1_VALUE1_VALUE }
  it { expect(DummyConf::SECTION1::VALUE1).to eq S1_VALUE1_VALUE }
  it { expect(DummyConf::SECTION1.value1).to eq S1_VALUE1_VALUE }
  it { expect(DummyConf.section1.value2).to eq S1_VALUE2_VALUE }
  it { expect(DummyConf.section1::VALUE2).to eq S1_VALUE2_VALUE }
  it { expect(DummyConf::SECTION1::VALUE2).to eq S1_VALUE2_VALUE }
  it { expect(DummyConf::SECTION1.value2).to eq S1_VALUE2_VALUE }

  # In section 2
  it { expect(DummyConf.section1.section2.value1).to eq S2_VALUE1_VALUE }
  it { expect(DummyConf.section1.section2::VALUE1).to eq S2_VALUE1_VALUE }
  it { expect(DummyConf.section1::SECTION2::VALUE1).to eq S2_VALUE1_VALUE }
  it { expect(DummyConf.section1::SECTION2.value1).to eq S2_VALUE1_VALUE }
  it { expect(DummyConf.section1.section2.value2).to eq S2_VALUE2_VALUE }
  it { expect(DummyConf.section1.section2::VALUE2).to eq S2_VALUE2_VALUE }
  it { expect(DummyConf.section1::SECTION2::VALUE2).to eq S2_VALUE2_VALUE }
  it { expect(DummyConf.section1::SECTION2.value2).to eq S2_VALUE2_VALUE }
end
