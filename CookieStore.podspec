Pod::Spec.new do |s|
  s.name             = "CookieStore"
  s.version          = "1.0.0"
  s.summary          = "ios http cookie storage"
  s.homepage         = "http://github.com/Econa77/CookieStore"
  s.license          = 'MIT'
  s.author           = { "Shunsuke Furubayashi" => "f.s.1992.ip@gmail.com" }
  s.source           = { :git => "git@github.com:Econa77/CookieStore.git", :tag => "v#{s.version}" }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Lib/CookieStore/*.swift'
end
