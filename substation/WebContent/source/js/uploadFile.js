function $init_file_upload() {
    var $file_logicId = '';
    var isUpload = true;
    var errorMessage = '';
    var uploader = new plupload.Uploader({
        runtimes: 'html5,html4',
        browse_button: 'open-lyy',
        multi_selection: false,
        //url: '/jsvc/service/DP_templateExcel/uploadExcel.json',
        url:'/user/upload',
        filters: {
            max_file_size: '10mb',
            mime_types: [
                {title: "Excel", extensions: "xls,xlsx"}
            ]
        },
        init: {
            BeforeUpload: function(uploader, fs) {
            	//在这里追加额外参数
            	//uploader.settings.url =  uploader.settings.url+'/'+1111111;
                loadingStart('上传中。。。');
            },
            FilesAdded: function(up, files) {
                uploader.start();
            },
            FileUploaded: function(up, file, info) {
            	var status = '';
                try {
                	status = (eval('(' + info.response + ')'));
                } catch (e) {
                	status = (eval('(' + $(info.response).html() + ')'));
                }
                try{
                	isUpload = status.success;
                	errorMessage = status.message;
                    $file_logicId = status.result.logicFileId;
                }catch(e){}
            },
            UploadComplete: function(up, files) {
                if (isUpload) {
                    loadingEnd();
                    layer.alert(errorMessage);
                    refreshGrid();
                }else{
                	loadingEnd();
                	layer.alert(errorMessage);
                }
            }
        }
    });
    uploader.init();
}

function loadingStart(msg) {
    $("<div class=\"datagrid-mask\"></div>").css({display: "block", width: "100%", height: $(window).height(), zIndex: 9999}).appendTo("body");
    $("<div class=\"datagrid-mask-msg\"></div>").html(msg).appendTo("body").css({display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2, zIndex: 9999});
}
function loadingEnd() {
    $(".datagrid-mask").remove();
    $(".datagrid-mask-msg").remove();
}
