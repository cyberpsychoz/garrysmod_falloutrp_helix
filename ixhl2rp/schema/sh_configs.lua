ix.currency.symbol = ""
ix.currency.singular = "крышка"
ix.currency.plural = "caps"

ix.config.SetDefault("scoreboardRecognition", true)
ix.config.SetDefault("music", "FalloutMusic/MainTheme.mp3")
ix.config.SetDefault("maxAttributes", 60)

ix.config.Add("rationTokens", 20, "The amount of tokens that a person will get from a ration", nil, {
	data = {min = 0, max = 1000},
	category = "economy"
})

ix.config.Add("rationInterval", 300, "How long a person needs to wait in seconds to get their next ration", nil, {
	data = {min = 0, max = 86400},
	category = "economy"
})
