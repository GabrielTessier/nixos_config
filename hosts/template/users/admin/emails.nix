{
  accounts.email.accounts = {
    mail = {
      address = "admin@example.com";
      realName = "admin";
      primary = true;
      userName = "admin@example.com";
      imap = {
        host = "imap.example.com";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "smtp.example.com";
        port = 465;
        tls.enable = true;
      };
      thunderbird.enable = true;
    };
  };
}
