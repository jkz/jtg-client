$(document).ready( function() {
    $.roundImageURL = function (options, cb) {
        var r = options.radius || 24
        var d = r * 2;

        var target = document.createElement('canvas');
        target.width = d;
        target.height = d;
        targetCtx = target.getContext("2d");

        var original = document.createElement('canvas');
        original.width = d;
        original.height = d;
        var ctx = original.getContext("2d");
        ctx.arc(r,r,r,0,Math.PI*2,true); // you can use any shape
        ctx.clip();
        var img = new Image();
        img.addEventListener('load', function(e) {
            ctx.drawImage(this, 0, 0, d, d);
            imgData = ctx.getImageData(0,0,d,d);
            console.log('IMGDATA', imgData);
            targetCtx.putImageData(imgData,0,0);
            cb(target.toDataURL());
        }, true);
        img.src=options.src;
        return;

        var canvas = document.createElement('canvas');
        canvas.width = d;
        canvas.height = d;
        var ctx = canvas.getContext("2d");

        ctx.arc(r,r,r,0,Math.PI*2,true); // you can use any shape
        ctx.clip();

        var img = new Image();
        img.addEventListener('load', function(e) {
            ctx.drawImage(this, 0, 0, d, d);
            cb(canvas.toDataURL());
        }, true);
        img.src=options.src;
    }
});
