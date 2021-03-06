package "xfsprogs"
package "xfsdump"
package "xfslibs-dev"

# VirtIO device name mapping
if BlockDevice.on_kvm?

  cookbook_file "/usr/local/bin/virtio-to-scsi" do
    source "virtio-to-scsi"
    owner "root"
    mode 0755
  end

  cookbook_file "/etc/udev/rules.d/65-virtio-to-scsi.rules" do
    source "65-virtio-to-scsi.rules"
    owner "root"
    mode 0644
  end
  
  execute "Reload udev rules" do
    command "udevadm control --reload-rules"
  end

  execute "Let udev reprocess devices" do
    command "udevadm trigger"
  end

end

include_recipe "ebs::volumes"
unless node[:ebs][:raids].blank?
  include_recipe "ebs::raids"
end 

