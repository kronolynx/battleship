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

    var boardArray = Array(100).fill('x');
    var boardString = "";
    $(".ship").each(function () {
        var ship = $(this);
        var head = getShipAppendedPosition(ship);
        if (head != "shipYard") {
            var shipId = getShipId(ship);
            var step = getStep(ship);
            var tail = getShipTail(ship);

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
            success: function(e){

                console.log('ready');
            },
            error:function(e){
                console.log('Error on ready ' + e);
            }
        });
    }else {
        alert("All ships must be placed");
    }
}

function getShipSize(ship){
    return getShipSizeById(getShipId(ship));
}
/**
 *
 * @param shipId  id of the ship
 * @returns {number}
 */
function getShipSizeById(shipId) {
    var size = 0;
    if (shipId.indexOf("aircraft") > -1) {
        size = 5;
    } else if (shipId.indexOf("cruiser") > -1) {
        size = 3;
    } else {
        size = 2;
    }
    //console.log(shipId + " size " + size);
    return size;
}

/**
 *
 * @param ship
 * @returns {number} or NAN if the ship is in the shipyard
 */
function getStep(ship) {
    return getStepById(getShipId(ship))
}
function getStepById(shipId) {
    //console.log(getShipId(ship) + " step " + (getShipId(ship).indexOf('V') > -1 ? 10 : 1 ));
    return shipId.indexOf('V') > -1 ? 10 : 1;
}

function getShipTail(ship) {
    return getShipTailCalculated(getShipAppendedPosition(ship), getShipSize(ship), getStep(ship));
}

function getShipTailCalculated(calculatedPosition, size, step) {
    return (parseInt(calculatedPosition) + ((parseInt(size) - 1) * step));
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
/**
 *
 * @param shipId
 * @returns the char equivalent for this ship to use in the string board array
 */
function charFromShipId(shipId){
    return ships[1][ships[0].indexOf(shipId)];
}


function readyToAttack(isPlayerTurn) {
    if (isPlayerTurn )
    {
        activateClick();
    }
    else
    {
        deactivateClick();
    }
}

function isValidPosition(ship){
    // when horizontal the step is 10 because we calculate for a vertical ship and the difference is 10 boxes
    // the tail must be in a position that is less than 100
    var head = getShipAppendedPosition(ship);
    var shipSize = getShipSize(ship);
    return (isHorizontal(ship) && getShipTailCalculated(head,shipSize, 10) < 100) ||
           (isVertical(ship) && (( head % 10) <  (getShipTailCalculated(head,shipSize, 1) % 10 )));
}

function isVertical(ship){
    return getShipId(ship).indexOf('V') > -1 ;
}

function isHorizontal(ship){
    return !isVertical(ship);
}


/**
 * Append ship to board
 */
function appendShip(ship, pos) {
    ship.detach().appendTo($("#" + calculateShipPosition(getShipId(ship), pos)));
}

function calculateShipPosition(shipId, pos) {
    var headPos = "";
    if (shipId.indexOf("aircraft") > -1) {
        headPos = pos - (2 * getStepById(shipId));
    }
    else if (shipId.indexOf("cruiser") > -1) {
        headPos = pos - (1 * getStepById(shipId));
    } else {
        headPos = pos;
    }
    return headPos;
}

function checkCollision(ship){
    return checkCollisionById(getShipId(ship), getShipAppendedPosition(ship));
}
/**
 * Check if there's collision
 * @param shipId id of dragged ship
 * @param shipPos position of the ship
 * return true if collision found
 */
function checkCollisionById(shipId, shipPos) {
    var collision = false;
    $(".ship").each(function () {
        var otherShip = $(this);
        var otherId = getShipId(otherShip);
        var otherPos = getShipAppendedPosition(otherShip);
        if (shipId != otherId && shipPos != "shipYard") {
            if (comparePosition(shipPos, otherPos, getShipSizeById(shipId), getShipSizeById(otherId), getStepById(shipId), getStepById(otherId))) {
                collision = true;
                // return false to break out of the loop
                return false;
            }
        }
    });
    return collision;
}

/**
 *
 * @param calculatedPosShipDragged position of the dragged ship
 * @param pos2 position of the other ship
 * @param size1 size of the ship at pos1
 * @param size2 size of the ship at pos2
 * @param step1 if is horizontal the step 1
 * @param step2 if is vertical the step is 10
 */
function comparePosition(calculatedPosShipDragged, pos2, size1, size2, step1, step2) {

    if (pos2 != "shipYard") {
        var tailShip1 = getShipTailCalculated(calculatedPosShipDragged, size1, step1);
        var tailShip2 = getShipTailCalculated(pos2, size2, step2);
        for (var i = parseInt(calculatedPosShipDragged); i <= tailShip1; i += step1) {
            for (var k = parseInt(pos2); k <= tailShip2; k += step2) {
                if (k == i) {
                    return true;
                }
            }
        }
    }
    return false;
}

