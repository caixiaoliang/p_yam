
$(document).on('turbolinks:load', function() {
  var editor;
  token = $("input[name=token]").val();

  var editor = new Simditor({
    textarea: $('.article_content'),
    fileKey: 'file',
    autosave: 'editor-content',
    upload: {
      url: 'http://upload.qiniu.com',
      params: {"token": token},
      fileKey: 'file',
      connectionCount: 3,
      leaveConfirm: 'Uploading is in progress, are you sure to leave this page?'
    },
    toolbar: ['title','strikethrough','fontScale','bold', 'italic', 'color', '|', 'ol', 'ul', '|', 'link', 'image', '|', 'indent', 'outdent', '|', 'hr',  'alignment', 'table','|','fullscreen']
  });
});
