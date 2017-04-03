try {
    CKEDITOR.editorConfig = function(config) {
        config.skin = 'minimalist';

        /* Filebrowser routes */
        // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
        config.filebrowserBrowseUrl = "/ckeditor/attachment_files";

        // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
        config.filebrowserFlashBrowseUrl = "/ckeditor/attachment_files";

        // The location of a script that handles file uploads in the Flash dialog.
        config.filebrowserFlashUploadUrl = "/ckeditor/attachment_files";

        // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
        config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";

        // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
        config.filebrowserImageBrowseUrl = "/ckeditor/pictures";

        // The location of a script that handles file uploads in the Image dialog.
        config.filebrowserImageUploadUrl = "/ckeditor/pictures";

        // The location of a script that handles file uploads.
        config.filebrowserUploadUrl = "/ckeditor/attachment_files";

        config.allowedContent = true;

        config.extraPlugins = 'widgetbootstrap';

        config.removeButtons = 'Form,Checkbox,Radio,TextField,Textarea,Select,ImageButton,HiddenField';
    };
} catch(e) {
    console.log("config error: " + e);
}

function loadCKConfig() {
    CKEDITOR.editorConfig = function(config) {
        config.skin = 'minimalist';

        /* Filebrowser routes */
        // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
        config.filebrowserBrowseUrl = "/ckeditor/attachment_files";

        // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
        config.filebrowserFlashBrowseUrl = "/ckeditor/attachment_files";

        // The location of a script that handles file uploads in the Flash dialog.
        config.filebrowserFlashUploadUrl = "/ckeditor/attachment_files";

        // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
        config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";

        // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
        config.filebrowserImageBrowseUrl = "/ckeditor/pictures";

        // The location of a script that handles file uploads in the Image dialog.
        config.filebrowserImageUploadUrl = "/ckeditor/pictures";

        // The location of a script that handles file uploads.
        config.filebrowserUploadUrl = "/ckeditor/attachment_files";

        config.allowedContent = true;

        config.extraPlugins = 'widgetbootstrap';

        config.removeButtons = 'Form,Checkbox,Radio,TextField,Textarea,Select,ImageButton,HiddenField';
    };
}