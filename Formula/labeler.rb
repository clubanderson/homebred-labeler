class Labeler < Formula
  desc "Utility that automates the labeling of resources output from kubectl, kustomize, and helm"
  homepage "https://github.com/clubanderson/labeler"
  url "https://github.com/clubanderson/labeler/archive/refs/tags/v0.18.4.tar.gz"
  # url "https://github.com/clubanderson/labeler/releases/download/v0.18.4/labeler"
  # sha256 "26c5d47adbd0ed7d0a0d9f8a33a25bc242f7cdff2a661d8d6211f5279ca995d4"

  def install
    os = `uname -s`.strip.downcase
    arch = `uname -m`.strip.downcase

    case "#{os}_#{arch}"
    when "linux_386"
      bin.install "https://github.com/clubanderson/labeler/releases/download/v0.18.4/labeler-linux-386" => "labeler"
    when "linux_amd64"
      bin.install "https://github.com/clubanderson/labeler/releases/download/v0.18.4/labeler-linux-amd64" => "labeler"
    when "linux_x86_64"
      bin.install "https://github.com/clubanderson/labeler/releases/download/v0.18.4/labeler-linux-amd64" => "labeler"      
    when "linux_arm"
      bin.install "https://github.com/clubanderson/labeler/releases/download/v0.18.4/labeler-linux-arm" => "labeler"
    when "linux_arm64"
      bin.install "https://github.com/clubanderson/labeler/releases/download/v0.18.4/labeler-linux-arm64" => "labeler"
    when "darwin_arm64"
      bin.install "https://github.com/clubanderson/labeler/releases/download/v0.18.4/labeler-darwin-arm64" => "labeler"
    when "darwin_amd64"
      bin.install "https://github.com/clubanderson/labeler/releases/download/v0.18.4/labeler-darwin-amd64" => "labeler"
    when "windows_386"
      bin.install "https://github.com/clubanderson/labeler/releases/download/v0.18.4/labeler-windows-386.exe" => "labeler.exe"
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
