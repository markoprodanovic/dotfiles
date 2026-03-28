return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              files = {
                exclude = {
                  "**/.git/**",
                  "**/.svn/**",
                  "**/.hg/**",
                  "**/CVS/**",
                  "**/.DS_Store/**",
                  "**/node_modules/**",
                  "**/bower_components/**",
                  "**/vendor/**/{Tests,tests}/**",
                  "**/.history/**",
                  "**/vendor/**/vendor/**",
                  -- Magento 2 specific exclusions
                  "**/pub/static/**",
                  "**/pub/media/**",
                  "**/var/**",
                  "**/setup/**",
                },
              },
              stubs = {
                -- Default stubs
                "apache", "bcmath", "bz2", "calendar", "com_dotnet",
                "Core", "ctype", "curl", "date", "dba", "dom", "enchant",
                "exif", "FFI", "fileinfo", "filter", "fpm", "ftp", "gd",
                "gettext", "gmp", "hash", "iconv", "imap", "intl", "json",
                "ldap", "libxml", "mbstring", "meta", "mysqli", "oci8",
                "odbc", "openssl", "pcntl", "pcre", "PDO", "pgsql", "Phar",
                "posix", "pspell", "random", "readline", "Reflection",
                "session", "shmop", "SimpleXML", "snmp", "soap", "sockets",
                "sodium", "SPL", "sqlite3", "standard", "superglobals",
                "sysvmsg", "sysvsem", "sysvshm", "tidy", "tokenizer",
                "xml", "xmlreader", "xmlrpc", "xmlwriter", "xsl",
                "Zend OPcache", "zip", "zlib",
                -- Magento 2 commonly used extensions
                "redis",
                "xdebug",
              },
              environment = {
                phpVersion = "8.2.0",
              },
            },
          },
        },
      },
    },
  },

  -- Configure phpcs and phpmd to use the team's rulesets
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        php = { "phpcs", "phpmd" },
      },
      linters = {
        phpcs = {
          args = {
            "-q",
            "--report=json",
            "--standard=dev/phpcs/ruleset.xml",
            function()
              return "--stdin-path=" .. vim.fn.expand("%:p:.")
            end,
            "-",
          },
        },
        phpmd = {
          args = {
            "-",
            "json",
            "dev/phpmd/magento2.xml",
          },
        },
      },
    },
  },
}
