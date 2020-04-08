CKEDITOR.editorConfig = function( config ) {
  config.extraPlugins = 'youtube';

  config.allowedContent = true;

  // Youtube plugin configs
  config.youtube_width = '640';
  config.youtube_height = '480';
  config.youtube_controls = true;

  config.filebrowserImageBrowseUrl = "/ckeditor/pictures";
  config.filebrowserImageUploadUrl = "/ckeditor/pictures?";

  config.stylesSet = 'articles_styles';
}

CKEDITOR.stylesSet.add( 'articles_styles', [
  { name: 'Header 1', element: 'h1' },
  { name: 'Header 2',  element: 'h2' },
  { name: 'List with icons', element: 'div', attributes: { 'class': 'prices-from-masters' } },
  { name: 'Gallery', element: 'div', attributes: { 'class': 'fotorama', 'data-width': '100%', 'data-ratio': "800/600" } },
  { name: 'Text', element: 'p' },
  { name: 'Image', element: 'img' },

  // Blockquotes
  { name: 'Blockquote right', element: 'blockquote', attributes: { 'class': 'cols_right' } },
  { name: 'Blockquote left', element: 'blockquote', attributes: { 'class': 'cols_left' } },
  
  // Advice with span title element
  { name: 'Advice', element: 'p', attributes: { 'class': 'advice' }},
  { name: 'Advice header', element: 'span' },

  { name: 'Link', element: 'a', attributes: { 'class': 'qjob-post-link' }},
  
  //Videos
  { name: 'Video styles', element: 'p', attributes: { 'class': 'video' }},

  // Images
  { 
    name: 'Vertical img 50%',
    element: 'img', 
    attributes: {
      'style': 'display: block;\
                margin-left: auto;\
                margin-right: auto;\
                width: 50%;' 
    }
  },
  
  { name: 'Image desc', element: 'span', attributes: { 'class': 'image_description' } }
]);