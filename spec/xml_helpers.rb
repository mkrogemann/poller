module XMLHelpers
  def simple_valid_xml
    <<-EOF
    <?xml version='1.0' encoding='UTF-8'?>
    <A id='dumpty'>
      <B>humpty</B>
    </A>
    EOF
  end

  def two_agents_xml
    <<-EOF
    <?xml version='1.0' encoding='UTF-8'?>
    <Agents>
      <Agent>001</Agent>
      <Agent>002</Agent>
    </Agents>
    EOF
  end
end