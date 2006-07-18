var tl;
function onLoad() {
  var eventSource   = new Timeline.DefaultEventSource();
  var bandInfos = [
    Timeline.createBandInfo({
        eventSource:    eventSource,
        width:          "70%",
        intervalUnit:   Timeline.DateTime.HOUR,
        intervalPixels: 300
    }),
    Timeline.createBandInfo({
        eventSource:    eventSource,
        width:          "30%",
        intervalUnit:   Timeline.DateTime.DAY,
        intervalPixels: 400
    })
  ];
  bandInfos[1].syncWith = 0;
  bandInfos[1].highlight = true;

  var tl = Timeline.create(document.getElementById("playlist-timeline"), bandInfos);
  Timeline.loadXML("/playlists/timeline_xml", function(xml, url) { eventSource.loadXML(xml, url); });
}

var resizeTimerID = null;
function onResize() {
    if (resizeTimerID == null) {
        resizeTimerID = window.setTimeout(function() {
            resizeTimerID = null;
            tl.layout();
        }, 500);
    }
}