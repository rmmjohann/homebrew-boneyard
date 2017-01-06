class Peervpn < Formula
  desc "Peer-to-peer VPN"
  homepage "https://peervpn.net/"
  url "https://peervpn.net/files/peervpn-0-041.tar.gz"
  version "0.041"
  sha256 "94a7b649a973c1081d3bd9499bd7410b00b2afc5b4fd4341b1ccf2ce13ad8f52"

  depends_on "openssl"
  depends_on :tuntap

  patch :DATA if MacOS.version == :snow_leopard

  def install
    system "make"
    bin.install "peervpn"
    etc.install "peervpn.conf"
  end

  def caveats; <<-EOS.undent
    To configure PeerVPN, edit:
      #{etc}/peervpn.conf
    EOS
  end
  
  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/peervpn</string>
          <string>#{etc}/peervpn.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{opt_bin}/..</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/peervpn/error.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/peervpn/out.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/peervpn"
  end
end

__END__
diff --git a/platform/io.c b/platform/io.c
index 209666a..0a6c2cf 100644
--- a/platform/io.c
+++ b/platform/io.c
@@ -24,6 +24,16 @@
 #if defined(__FreeBSD__)
 #define IO_BSD
 #elif defined(__APPLE__)
+size_t strnlen(const char *s, size_t maxlen)
+{
+        size_t len;
+
+        for (len = 0; len < maxlen; len++, s++) {
+                if (!*s)
+                        break;
+        }
+        return (len);
+}
 #define IO_BSD
 #define IO_USE_SELECT
 #elif defined(WIN32)
