# Load fonts for the code depending on the runtime environment
function hfun_load_fonts()
    if get(ENV, "GITHUB_ACTIONS", "false") == "true"
        prepath = "/wiki"
    else
        prepath = ""
    end
    return """
    <style>
      @font-face {
          font-family: Inconsolata;
          src: url("$(prepath)/assets/fonts/Inconsolata-Regular.ttf") format('truetype');
          font-weight: 400;
          font-style: normal;
      }

      @font-face {
          font-family: Inconsolata;
          src: url("$(prepath)/assets/fonts/Inconsolata-Medium.ttf") format('truetype');
          font-weight: 500;
          font-style: normal;
      }

      @font-face {
          font-family: Inconsolata;
          src: url("$(prepath)/assets/fonts/Inconsolata-SemiBold.ttf") format('truetype');
          font-weight: 600;
          font-style: normal;
      }

      @font-face {
          font-family: Inconsolata;
          src: url("$(prepath)/assets/fonts/Inconsolata-Bold.ttf") format('truetype');
          font-weight: 700;
          font-style: normal;
      }
    </style>
    """
end
