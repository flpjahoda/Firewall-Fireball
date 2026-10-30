function block_element(_el)  { return { type: "element", value: _el }; }
function block_shoot(_speed) { return { type: "shoot", speed: _speed }; }
function block_wait(_frames) { return { type: "wait", frames: _frames }; }

function element_color(_el) {
    switch (_el) {
        case "fire":  return c_orange;
        case "water": return c_aqua;
        default:      return c_yellow;
    }
}
function block_repeat(_times, _body) { return { type: "repeat", times: _times, body: _body }; }

// rozbalí "Opakuj" na obyčejný plochý seznam bloků
function flatten_blocks(_blocks) {
    var out = [];
    for (var i = 0; i < array_length(_blocks); i++) {
        var b = _blocks[i];
        if (b.type == "repeat") {
            var inner = flatten_blocks(b.body);
            var times = min(b.times, 100);   // pojistka proti obřím smyčkám
            for (var t = 0; t < times; t++) {
                for (var j = 0; j < array_length(inner); j++) {
                    array_push(out, inner[j]);
                }
            }
        } else {
            array_push(out, b);
        }
    }
    return out;
}