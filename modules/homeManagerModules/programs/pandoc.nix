{self, ...}:{
  programs.pandoc = {
    enable = true;
    defaultsFile = "${self.outPath}/extra/pandoc/pandoc-defaults.yaml";
    # templates = {
    #   "default.latex" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
    #   "default.markdown" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
    #   "default.pdf" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
    # };
  };
}
