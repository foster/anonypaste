function toggleInfoBox(target)
{
    if (toggleInfoBox.inProgress == true)
        return;

    toggleInfoBox.inProgress = true;
    if (target.is(":visible"))
    {
        target.slideUp(300, function ()
        {
            $("#pasteBodyContainer").animate({ height: "+=200" }, 400, function ()
            {
                toggleInfoBox.inProgress = false;
                $("#helpIcon").effect("highlight");
                $("#pasteBody").focus();
            });
        });
    }
    else
    {
        $("#pasteBodyContainer").animate({ height: "-=200" }, 400, function ()
        {
            target.slideDown(400, function ()
            {
                toggleInfoBox.inProgress = false;
                $("#pasteBody").focus();
            });
        });
    }
}

$(document).ready(function ()
{
    if ($('.notify').length == 0)
    {
        $('#helpIcon').hide();
    }

    $('.notifyClose').click(function ()
    {
        toggleInfoBox($(this).parent());
    });

    $('#helpIcon').click(function ()
    {
        toggleInfoBox($("#about"));
    });

    $('#pasteBody').focus();
});