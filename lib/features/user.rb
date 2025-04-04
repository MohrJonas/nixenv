# frozen_string_literal: true

require 'json'
require 'etc'

require_relative '../incus'
require_relative '../templates'
require_relative '../fs'

class User
  def self.apply(instance_name, feature_config)
    user_name = Etc.getlogin
    info = Etc.getpwnam(user_name)
    user_uid = info.uid
    user_primary_group_gid = info.gid
    user_primary_group_name = Etc.getgrgid(user_primary_group_gid).name
    config = {
      users: {
        groups: {
          user_primary_group_name => {
            gid: user_primary_group_gid
          }
        },
        users: {
          user_name => {
            isNormalUser: true,
            password: "nixenv",
            extraGroups: ["wheel"],
            group: user_primary_group_name,
            uid: user_uid,
          }
        }
      },
      security: {
        sudo: {
          wheelNeedsPassword: false
        }
      }
    }

    FS.nixenv_feature_file(Dir.pwd, 'user.nix').write(Templates.json_flake(JSON.dump(config).gsub('"', '\"')))
  end

  def self.unapply(instance_name)
    FS.nixenv_feature_file(Dir.pwd, 'user.nix').delete
  end
end
