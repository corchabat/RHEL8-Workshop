- hosts: workstation
  tasks:
  
    - name: "TEMPLATE modify /etc/motd"
      template:
        src: motd-generic.j2
        dest: /etc/motd
        owner: root
        group: root
        mode: 0644  

    - name: "SERVICE disable and stop unwanted services"
      service: 
        name="{{ item.name }}"
        state=stopped
        enabled=no
      with_items:
        - {name: 'packagekit'}
        - {name: 'rhsmcertd'}
        - {name: 'libvirtd'}
        - {name: 'dnsmasq'}

    - name: "CMD disable yum plugins for rhn and subscription-manager"
      shell: 
        cmd: |          
          sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/rhnplugin.conf
          sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/subscription-manager.conf
          sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/product-id.conf