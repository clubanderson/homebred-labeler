class Labeler < Formula
  desc "Utility that automates the labeling of resources output from kubectl, kustomize, and helm"
  homepage "https://github.com/clubanderson/labeler"
  version "v0.18.4"

  url_base = "https://github.com/clubanderson/labeler/releases/download/#{version}"

  if OS.mac?
    case Hardware::CPU.arch
    when :arm64
      url "#{url_base}/labeler-darwin-arm64"
    when :x86_64
      url "#{url_base}/labeler-darwin-amd64"
    else
      odie "Unsupported architecture #{Hardware::CPU.arch} on macOS"
    end
  elsif OS.linux?
    case Hardware::CPU.arch
    when :arm64
      url "#{url_base}/labeler-linux-arm64"
    when :arm
      url "#{url_base}/labeler-linux-arm"
    when :x86_64
      url "#{url_base}/labeler-linux-amd64"
    when :i386
      url "#{url_base}/labeler-linux-386"
    when :ppc64
      url "#{url_base}/labeler-linux-ppc64"
    when :ppc64le
      url "#{url_base}/labeler-linux-ppc64le"
    when :s390x
      url "#{url_base}/labeler-linux-s390x"
    else
      odie "Unsupported architecture #{Hardware::CPU.arch} on Linux"
    end
  elsif OS.windows?
    case Hardware::CPU.arch
    when :amd64
      url "#{url_base}/labeler-windows-amd64.exe"
    when :i386
      url "#{url_base}/labeler-windows-386.exe"
    else
      odie "Unsupported architecture: #{Hardware::CPU.arch} on Windows"
    end
  elsif OS.freebsd?
    case Hardware::CPU.arch
    # when :amd64
    #   url "#{url_base}/labeler-freebsd-amd64"
    when :i386
      url "#{url_base}/labeler-freebsd-386"
    else
      odie "Unsupported architecture: #{Hardware::CPU.arch} on FreeBSD"
    end
  else
    odie "Unsupported operating system"
  end

  license "Apache-2.0"

  if system("which kubectl &> /dev/null")
    depends_on "kubectl"
  end
  
  def install
    os = `uname -s`.strip.downcase
    arch = `uname -m`.strip.downcase

    case "#{os}_#{arch}"
    when "linux_386"
      bin.install "labeler-linux-386" => "labeler"
    when "linux_amd64"
      bin.install "labeler-linux-amd64" => "labeler"
    when "linux_x86_64"
      bin.install "labeler-linux-amd64" => "labeler"      
    when "linux_arm"
      bin.install "labeler-linux-arm" => "labeler"
    when "linux_arm64"
      bin.install "labeler-linux-arm64" => "labeler"
    when "darwin_arm64"
      bin.install "labeler-darwin-arm64" => "labeler"
    when "darwin_amd64"
      bin.install "labeler-darwin-amd64" => "labeler"
    when "windows_386"
      bin.install "labeler-windows-386.exe" => "labeler.exe"
    else
      odie "Unsupported architecture: #{os}_#{arch}"
    end
    
    # bin.install "labeler"
  end

  test do
    system "#{bin}/labeler", "--version"
  end

  # After installing, create aliases for convenience
  def caveats
    <<~EOS
      To make using labeler more convenient, consider creating aliases:
      \e[33malias k="labeler kubectl"\e[0m
      \e[33malias h="labeler helm"\e[0m

      (if you want these to be permanent, add these to your shell profile, e.g. ~/.bashrc or ~/.zshrc, then source it)

      Then just use `k` or `h` in place of `kubectl` or `helm` respectively. Add -l or --label= to the end of the command to label ALL of the resources you apply.

      example (kubectl):
        
         k apply -f examples/kubectl/pass \e[33m-l app.kubernetes.io/part-of=sample\e[0m --context=kind-kind --namespace=default --overwrite

      example (kustomize):

         k apply -k examples/kustomize \e[33m-l app.kubernetes.io/part-of=sample-app\e[0m --context=kind-kind --namespace=temp --overwrite

      example (helm):

         h --kube-context=kind-kind template sealed-secrets sealed-secrets/sealed-secrets -n sealed-secrets --create-namespace \e[33m--label=app.kubernetes.io/part-of=sample-app\e[0m --dry-run   
      
      get help, including all possible accepted args from labeler and it's plugins, with:
        h --l-help
        k --l-help

      For more information, or to make labeler better, visit the readme at \e[33mhttps://github.com/clubanderson/labeler\e[0m
    EOS
  end
end
