{self, ...}:{
  programs.pandoc = {
    enable = true;
    defaults = {
      toc = true;
      from = "markdown+hard_line_breaks";
    };
    # templates = {
    #   "default.latex" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
    #   "default.markdown" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
    #   "default.pdf" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
    # };
  };
}
