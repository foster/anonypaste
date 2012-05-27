function setActiveTab(lang)
{
	if (!lang)
		var lang=window.location.hash

	$("#lang-selector .active").removeClass("active")
	$("#lang-selector a[href='" + lang + "']").parent().addClass("active")
}

function setHighlightLanguage(lang)
{
	if (!lang)
		var lang=window.location.hash

	if (lang.substring(0,1) == "#")
		lang = lang.substring(1, lang.length)

	$("#pasteBody code").removeClass();

	switch (lang)
	{
		case "":
			$("#pasteBody code").addClass("highlight");
			break;
		case "none":
			break;
		case "csharp":
			$("#pasteBody code").addClass("prettyprint language-cs");
			break;
		default:
			$("#pasteBody code").addClass("prettyprint language-" + lang);
			break;
	}
}

$(function() {
	//setActiveTab()
});

$("#lang-selector a").click(function() {
	setActiveTab($(this).attr('href'))
	setHighlightLanguage($(this).attr('href'))
});

