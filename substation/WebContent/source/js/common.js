function show(){
	if($('#show_id').length > 0){
		$('#show_id').show();
	}else{
		var mark = $('<div id="show_id" style="width: 100%;height: 100%;z-index: 98;left: 0;top: 0;position: fixed;background-color: rgba(51, 51, 51, 0.3);filter: progid:DXImageTransform.Microsoft.gradient(startcolorstr=#3333331E,endcolorstr=#3333331E);display:none"><div style="width: 110px;height: 30px;left: 50%;top : 50%;position: fixed;margin-left: -55px;margin-top: -15px;background: url(../source/image/innerpicloading.gif) no-repeat;z-index: 99;"></div></div>');
		mark.appendTo("body").show();
	}
}
function hidden(){
	$('#show_id').hide();
}

function loadingStart(msg) {
    $("<div class=\"datagrid-mask\"></div>").css({display: "block", width: "100%", height: $(window).height(), zIndex: 9999}).appendTo("body");
    $("<div class=\"datagrid-mask-msg\"></div>").html(msg).appendTo("body").css({display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2, zIndex: 9999,"height":"38px",});
}
function loadingEnd() {
    $(".datagrid-mask").remove();
    $(".datagrid-mask-msg").remove();
}

/**
 * @param {type} s
 * @returns {Boolean}
 */
String.prototype.endWith = function(s) {
    if (s === null || s === "" || this.length === 0 || s.length > this.length)
        return false;
    if (this.substring(this.length - s.length) === s)
        return true;
    else
        return false;
    return true;
};
String.prototype.startWith = function(s) {
    if (s === null || s === "" || this.length === 0 || s.length > this.length)
        return false;
    if (this.substr(0, s.length) === s)
        return true;
    else
        return false;
    return true;
};
String.prototype.isEmpty = function(s) {
    	return s === null || s === "" || s === undefined ;
};

function getURLParamsMap() {
    var url = location.search;
    var m = new Map();
    if (url.indexOf("?") !== -1) {
        var strs = url.substr(1).split("&");
        for (var i = 0; i < strs.length; i++) {
            var str_array = strs[i].split("=");
            m.put(str_array[0], str_array[1]);
        }
    }
    return m;
}

function getParamsMapWithStr(str){
	var m = new Map();
	var strs = str.split("&");
	for (var i = 0; i < strs.length; i++) {
        var str_array = strs[i].split("=");
        m.put(str_array[0], str_array[1]);
    }
	return m;
}

Array.prototype.remove = function(s) {
    for (var i = 0; i < this.length; i++) {
        if (s === this[i])
            this.splice(i, 1);
    }
};

function arr_dive(aArr, bArr) {   //第一个数组减去第二个数组
    if (bArr.length === 0) {
        return aArr;
    }
    var diff = [];
    var str = bArr.join(",");
    for (var e in aArr) {
        if (str.indexOf(aArr[e]) === -1) {
            diff.push(aArr[e]);
        }
    }
    return diff;
}
function Map() {
    /** 存放键的数组(遍历用到) */
    this.keys = new Array();
    /** 存放数据 */
    this.data = new Object();

    /**
     * 放入一个键值对
     * @param {String} key
     * @param {Object} value
     */
    this.put = function(key, value) {
        if (this.data[key] == null) {
            this.keys.push(key);
        }
        this.data[key] = value;
    };

    /**
     * 获取某键对应的值
     * @param {String} key
     * @return {Object} value
     */
    this.get = function(key) {
        return this.data[key];
    };

    /**
     * 删除一个键值对
     * @param {String} key
     */
    this.remove = function(key) {
        this.keys.remove(key);
        this.data[key] = null;
    };

    /**
     * 遍历Map,执行处理函数
     *
     * @param {Function} 回调函数 function(key,value,index){..}
     */
    this.each = function(fn) {
        if (typeof fn != 'function') {
            return;
        }
        var len = this.keys.length;
        for (var i = 0; i < len; i++) {
            var k = this.keys[i];
            fn(k, this.data[k], i);
        }
    };

    /**
     * 获取键值数组(类似Java的entrySet())
     * @return 键值对象{key,value}的数组
     */
    this.entrys = function() {
        var len = this.keys.length;
        var entrys = new Array(len);
        for (var i = 0; i < len; i++) {
            entrys[i] = {
                key: this.keys[i],
                value: this.data[i]
            };
        }
        return entrys;
    };

    /**
     * 判断Map是否为空
     */
    this.isEmpty = function() {
        return this.keys.length === 0;
    };

    /**
     * 获取键值对数量
     */
    this.size = function() {
        return this.keys.length;
    };

    /**
     * 重写toString
     */
    this.toString = function() {
        var s = "{";
        for (var i = 0; i < this.keys.length; i++, s += ',') {
            var k = this.keys[i];
            s += k + "=" + this.data[k];
        }
        s = s.substr(0, s.length - 1) + "}";
        return s;
    };

    /**
     * 转为对象
     */
    this.toObject = function() {
        var obj = {};
        for (var i = 0; i < this.keys.length; i++) {
            var key = this.keys[i];
            var value = this.data[key];
            obj[key] = value;
        }
        return obj;
    };
}

