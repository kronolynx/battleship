var ships = [["aircraft", "aircraftV", "destroyer1", "destroyer1V", "destroyer2", "destroyer2V", "cruiser1", "cruiser1V", "cruiser2", "cruiser2V"],
    ['a', 'c', 'e', 'g', 'i', 'k', 'm', 'o', 'q', 's']];

function generateBoard() {
    var board = "";
    for (var i = 0; i < 100; i++) {
        board += "<div class='seaBox' id='" + i + "'></div>";
    }
    return board;
}

function displayPlayerShips(board){
    var ignoreChar = "x"
    for(var i = 0; i < 100; i++){
        if(ignoreChar.indexOf(board[i]) == -1){
            setShip(i, board[i]);
            ignoreChar+= board[i];
        }
    }
}

function setShip(pos, char){
    $("#" + pos).append("<div class='ship' id='" + shipIdFromChar(char) + "'></div>")
}

/**
 * set the initial board where the ships will be placed, TODO find a better name
 */
function setBoardPlacement() {
    // TODO ecmascript6 use for loop instead because old browsers may not work

    var boardArray = Array(100).fill('x')
    var boardString = "";
    $(".ship").each(function () {
        var head = getShipAppendedPosition($(this));
        if (head != "shipYard") {
            var shipId = getShipId($(this));
            var step = getStep(shipId);
            var tail = getShipTail(head, getShipSize(shipId), step);

            for (var i = parseInt(head); i <= tail; i += step) {
                boardArray[i] = charFromShipId(shipId);
            }
            boardString = boardArray.join("");
        }
        else{
            boardString = "";
            return false;
        }
    });
    if(boardString){
        var battleField = $('#battle-field');
        var battleId = battleField.data('battleId');
        var playerId = battleField.data('playerId');

        //alert(battleId);
        $.ajax({
            url: "/battle/"+ battleId + "/ready?board=" + boardString,
            type: "post",
            success: function(){
                console.log('successful attack');
            },
            error:function(){
                alert('Error');
            }
        });
    }else {
        alert("All ship must be placed");
    }
    console.log(boardString);
}

/**
 *
 * @param shipId  id of the ship
 * @returns {number}
 */
function getShipSize(shipId) {
    var size = 0;
    if (shipId.indexOf("aircraft") > -1) {
        size = 5;
    } else if (shipId.indexOf("cruiser") > -1) {
        size = 3;
    } else {
        size = 2;
    }
    return size;
}

/**
 *
 * @param shipId
 * @returns {number}
 */
function getStep(shipId) {
    return shipId.indexOf('V') > -1 ? 10 : 1;
}

function getShipTail(head, size, step) {
    return (parseInt(head) + ((parseInt(size) - 1) * step));
}

/**
 *
 * @param ship object
 * @returns {string}
 */
function getShipAppendedPosition(ship) {
    return ship.parent().attr('id');
}

function getShipId(ship) {
    return ship.attr("id");
}

function shipIdFromChar(char){
    return ships[0][ships[1].indexOf(char)];
}

function charFromShipId(shipId){
    return ships[1][ships[0].indexOf(shipId)];
}

function getNextChar(char){
    return String.fromCharCode(char.charCodeAt(0) + 1);
}

function getPrevChar(char){
    return String.fromCharCode(char.charCodeAt(0) + 1);
}