// Init default alert classes

CKEDITOR.plugins.add( 'widgetbootstrap', {
    requires: 'widget',

    icons: 'widgetbootstrapLeftCol,widgetbootstrapRightCol,widgetbootstrapTwoCol,widgetbootstrapThreeCol,widgetbootstrapContent',

    init: function( editor ) {
        
        // Configurable settings
        //var allowedWidget = editor.config.widgetbootstrap_allowedWidget != undefined ? editor.config.widgetbootstrap_allowedFull :
        //    'p h2 h3 h4 h5 h6 span br ul ol li strong em img[!src,alt,width,height]';
        var allowedFull = editor.config.widgetbootstrap_allowedFull != undefined ? editor.config.widgetbootstrap_allowedFull :
            'p a div span h2 h3 h4 h5 h6 section article iframe object embed strong b i em cite pre blockquote small sub sup code ul ol li dl dt dd table thead tbody th tr td img caption mediawrapper br[href,src,target,width,height,colspan,span,alt,name,title,class,id,data-options]{text-align,float,margin}(*);'
        //var allowedText = editor.config.widgetbootstrap_allowedText != undefined ? editor.config.widgetbootstrap_allowedFull :
        //    'p span br ul ol li strong em';


        allowedWidget = allowedFull;
        //allowedText = allowedWidget;

        var showButtons = editor.config.widgetbootstrapShowButtons != undefined ? editor.config.widgetbootstrapShowButtons : true;

        // Define the widgets
        editor.widgets.add( 'widgetbootstrapLeftCol', {

            button: showButtons ? 'Add left column box' : undefined,

            template:
                '<div class="row two-col-left">' +
                    '<div class="col-xs-12 col-md-3 col-sidebar"><p><img src="http://placehold.it/300x250&text=Image" /></p></div>' +
                    '<div class="col-xs-12 col-md-9 col-main"><p>Content</p></div>' +
                '</div>',

            editables: {
                col1: {
                    selector: '.col-sidebar',
                    allowedContent: allowedWidget
                },
                col2: {
                    selector: '.col-main',
                    allowedContent: allowedWidget
                }
            },

            allowedContent: allowedFull,

            upcast: function( element ) {
                return element.name == 'div' && element.hasClass( 'two-col-right-left' );
            }
            
        } );

        editor.widgets.add( 'widgetbootstrapRightCol', {

            button: showButtons ? 'Add right column box' : undefined,

            template:
                '<div class="row two-col-right">' +
                    '<div class="col-xs-12 col-md-9 col-main"><p>Content</p></div>' +
                    '<div class="col-xs-12 col-md-3 col-sidebar"><p><img src="http://placehold.it/300x250&text=Image" /></p></div>' +
                '</div>',

            editables: {
                col1: {
                    selector: '.col-sidebar',
                    allowedContent: allowedWidget
                },
                col2: {
                    selector: '.col-main',
                    allowedContent: allowedWidget
                }
            },

            allowedContent: allowedFull,

            upcast: function( element ) {
                return element.name == 'div' && element.hasClass( 'two-col-right' );
            }

        } );

        editor.widgets.add( 'widgetbootstrapTwoCol', {

            button: showButtons ? 'Add two column box' : undefined,

            template:
                '<div class="row two-col">' +
                    '<div class="col-xs-12 col-md-6 col-1"><p><img src="http://placehold.it/500x280&text=Image" /></p><p>Content</p></div>' +
                    '<div class="col-xs-12 col-md-6 col-2"><p><img src="http://placehold.it/500x280&text=Image" /></p><p>Content</p></div>' +
                '</div>',

            editables: {
                col1: {
                    selector: '.col-1',
                    allowedContent: allowedWidget
                },
                col2: {
                    selector: '.col-2',
                    allowedContent: allowedWidget
                }
            },

            allowedContent: allowedFull,

            upcast: function( element ) {
                return element.name == 'div' && element.hasClass( 'two-col' );
            }

        } );

        editor.widgets.add( 'widgetbootstrapThreeCol', {

            button: showButtons ? 'Add three column box' : undefined,

            template:
                '<div class="row three-col">' +
                    '<div class="col-xs-12 col-md-4 col-1"><p><img src="http://placehold.it/400x225&text=Image" /></p><p>Text below</p></div>' +
                    '<div class="col-xs-12 col-md-4 col-2"><p><img src="http://placehold.it/400x225&text=Image" /></p><p>Text below</p></div>' +
                    '<div class="col-xs-12 col-md-4 col-3"><p><img src="http://placehold.it/400x225&text=Image" /></p><p>Text below</p></div>' +
                '</div>',

            editables: {
                col1: {
                    selector: '.col-1',
                    allowedContent: allowedWidget
                },
                col2: {
                    selector: '.col-2',
                    allowedContent: allowedWidget
                },
                col3: {
                    selector: '.col-3',
                    allowedContent: allowedWidget
                }
            },

            allowedContent: allowedFull,

            upcast: function( element ) {
                return element.name == 'div' && element.hasClass( 'three-col' );
            }

        } );

        // Define the widgets
        editor.widgets.add( 'widgetbootstrapContent', {

            button: showButtons ? 'Add custom content' : undefined,

            template:
                '<div class="row custom-content-row">' +
                    '<div class="col-xs-12 col-custom col-headline">Headline</div>' +
                    '<div class="col-xs-12 col-custom col-description">Write your description here...</div>' +
                    '<div class="col-xs-12 col-custom col-image"><img src="http://placehold.it/400x225&text=Image" /></div>' +
                    '<div class="col-xs-12 col-custom col-body">Your main content here...</div>' +
                '</div>',

            editables: {
                col1: {
                    selector: '.col-headline',
                    allowedContent: allowedWidget
                },
                col2: {
                    selector: '.col-description',
                    allowedContent: allowedWidget
                },
                col3: {
                    selector: '.col-image',
                    allowedContent: allowedWidget
                },
                col4: {
                    selector: '.col-body',
                    allowedContent: allowedWidget
                }
            },

            // init: function() { 
            //     this.setData( 'width', '50%' );
            //     this.setData( 'align', 'left' );
            //     this.setData( 'display', 'inline-block' );
            // },

            allowedContent: allowedFull,

            upcast: function( element ) {
                return element.name == 'div' && element.hasClass( 'custom-content-row' );
            }
            
        } );

        // Append the widget's styles when in the CKEditor edit page,
        // added for better user experience.
        // Assign or append the widget's styles depending on the existing setup.
        if (typeof editor.config.contentsCss == 'object') {
            editor.config.contentsCss.push(CKEDITOR.getUrl(this.path + 'contents.css'));
        }
        else {
            editor.config.contentsCss = [editor.config.contentsCss, CKEDITOR.getUrl(this.path + 'contents.css')];
        }
    }
} );