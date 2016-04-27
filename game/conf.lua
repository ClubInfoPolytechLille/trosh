function love.conf(t)
	t.title = "TROSH: The Movie: The Game"
	t.author = "Maurice"
	t.console = false
	t.screen.vsync = true
	t.screen.width = 800
	t.screen.height = 640
	t.screen.fsaa = 0
    t.releases = {
        title = "Trosh Club Info",              -- The project title (string)
        package = "TroshCI",            -- The project command and package name (string)
        loveVersion = "0.8.0",        -- The project LÖVE version
        version = "1.1.0",            -- The project version
        author = "Club Info Polytech Lille",             -- Your name (string)
        email = "Club.Informatique@polytech-lille.fr",              -- Your email (string)
        description = "Jeu Trosh modifié par le Club Informatique",        -- The project description (string)
        homepage = "http://clubinfo.plil.net/trosh",           -- The project homepage (string)
        identifier = "com.ClubInfoPolytechLille.trosh",         -- The project Uniform Type Identifier (string)
    }
end
