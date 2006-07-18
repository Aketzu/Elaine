/////////////////////////////////////////////////////////////////////////////////////
// Modified and enhanced by: 
//      Nathaniel Brown - http://nshb.net
//      Email: nshb@inimit.com
//
// Created by: 
//      Simon Willison - http://simon.incutio.com
//
// Website:
//      http://datebox.inimit.com
//
// License:
//      GNU Lesser General Public License version 2.1 or above.
//      http://www.gnu.org/licenses/lgpl.html
//
// Bugs:
//      Please send comments and bugs to nshb@inimit.com
//
/////////////////////////////////////////////////////////////////////////////////////


// Configuration options

// Available date types (us|iso)
var configDateType = 'iso';

// Dates such as 2/29/2005 to rollover to 3/1/2005
var configAutoRollOver = true;


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

function keyListener(e) {
    if(!e){
	    //for IE
		e = window.event;
	}
	switch (e.keyCode) {
		case 10: // return
		case 13: // enter
			// perform the update
			magicDate('dateField');
			return false;
		default:
		    return true;
	}
}

switch (configDateType) {
    case 'us':
        var calendarIfFormat = '%m/%d/%Y';
        var calendarFormatString = 'mm/dd/yyyy';
        break;
    case 'iso':
    default:
        var calendarIfFormat = '%Y-%m-%d';
        var calendarFormatString = 'yyyy-mm-dd';
        break;
}       

// add indexOf function to Array type
// finds the index of the first occurence of item in the array, or -1 if not found
Array.prototype.indexOf = function(item) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == item) {
            return i;
        }
    }
    return -1;
};

// add filter function to Array type
// returns an array of items judged true by the passed in test function
Array.prototype.filter = function(test) {
    var matches = [];
    for (var i = 0; i < this.length; i++) {
        if (test(this[i])) {
            matches[matches.length] = this[i];
        }
    }
    return matches;
};

// add right function to String type
// returns the rightmost x characters
String.prototype.right = function( intLength ) {
   if (intLength >= this.length)
      return this;
   else
      return this.substr( this.length - intLength, intLength );
};

// add trim function to String type
// trims leading and trailing whitespace
String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, ''); };

// arrays for month and weekday names
var monthNames = "January February March April May June July August September October November December".split(" ");
var weekdayNames = "Sunday Monday Tuesday Wednesday Thursday Friday Saturday".split(" ");

/* Takes a string, returns the index of the month matching that string, throws
   an error if 0 or more than 1 matches
*/
function parseMonth(month) {
    var matches = monthNames.filter(function(item) { 
        return new RegExp("^" + month, "i").test(item);
    });
    if (matches.length == 0) {
        throw new Error("Invalid month string");
    }
    if (matches.length < 1) {
        throw new Error("Ambiguous month");
    }
    return monthNames.indexOf(matches[0]);
}

/* Same as parseMonth but for days of the week */
function parseWeekday(weekday) {
    var matches = weekdayNames.filter(function(item) {
        return new RegExp("^" + weekday, "i").test(item);
    });
    if (matches.length == 0) {
        throw new Error("Invalid day string");
    }
    if (matches.length < 1) {
        throw new Error("Ambiguous weekday");
    }
    return weekdayNames.indexOf(matches[0]);
}

function DateInRange( yyyy, mm, dd )
   {

   // if month out of range
   if ( mm < 0 || mm > 11 )
      throw new Error('Invalid month value.  Valid months values are 1 to 12');

   if (!configAutoRollOver) {
       // get last day in month
       var d = (11 == mm) ? new Date(yyyy + 1, 0, 0) : new Date(yyyy, mm + 1, 0);
    
       // if date out of range
       if ( dd < 1 || dd > d.getDate() )
          throw new Error('Invalid date value.  Valid date values for ' + monthNames[mm] + ' are 1 to ' + d.getDate().toString());
   }

   return true;

   }

function getDateObj(yyyy, mm, dd) {
    var obj = new Date();

    obj.setDate(dd);
    obj.setMonth(mm);
    obj.setYear(yyyy);
    
    return obj;
}

/* Array of objects, each has 're', a regular expression and 'handler', a 
   function for creating a date from something that matches the regular 
   expression. Handlers may throw errors if string is unparseable. 
*/
var dateParsePatterns = [
    // Today
    {   re: /^tod/i,
        handler: function() { 
            return new Date();
        } 
    },
    // Tomorrow
    {   re: /^tom/i,
        handler: function() {
            var d = new Date(); 
            d.setDate(d.getDate() + 1); 
            return d;
        }
    },
    // Yesterday
    {   re: /^yes/i,
        handler: function() {
            var d = new Date();
            d.setDate(d.getDate() - 1);
            return d;
        }
    },
    // 4th
    {   re: /^(\d{1,2})(st|nd|rd|th)?$/i, 
        handler: function(bits) {

            var d = new Date();
            var yyyy = d.getFullYear();
            var dd = parseInt(bits[1], 10);
            var mm = d.getMonth();

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // 4th Jan
    {   re: /^(\d{1,2})(?:st|nd|rd|th)? (?:of )?(\w+)$/i, 
        handler: function(bits) {

            var d = new Date();
            var yyyy = d.getFullYear();
            var dd = parseInt(bits[1], 10);
            var mm = parseMonth(bits[2]);

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // 4th Jan 2003
    {   re: /^(\d{1,2})(?:st|nd|rd|th)? (?:of )?(\w+),? (\d{4})$/i,
        handler: function(bits) {
            var d = new Date();
            d.setDate(parseInt(bits[1], 10));
            d.setMonth(parseMonth(bits[2]));
            d.setYear(bits[3]);
            return d;
        }
    },
    // Jan 4th
    {   re: /^(\w+) (\d{1,2})(?:st|nd|rd|th)?$/i, 
        handler: function(bits) {

            var d = new Date();
            var yyyy = d.getFullYear(); 
            var dd = parseInt(bits[2], 10);
            var mm = parseMonth(bits[1]);

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // Jan 4th 2003
    {   re: /^(\w+) (\d{1,2})(?:st|nd|rd|th)?,? (\d{4})$/i,
        handler: function(bits) {

            var yyyy = parseInt(bits[3], 10); 
            var dd = parseInt(bits[2], 10);
            var mm = parseMonth(bits[1]);

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // next Tuesday - this is suspect due to weird meaning of "next"
    {   re: /^next (\w+)$/i,
        handler: function(bits) {

            var d = new Date();
            var day = d.getDay();
            var newDay = parseWeekday(bits[1]);
            var addDays = newDay - day;
            if (newDay <= day) {
                addDays += 7;
            }
            d.setDate(d.getDate() + addDays);
            return d;

        }
    },
    // last Tuesday
    {   re: /^last (\w+)$/i,
        handler: function(bits) {

            var d = new Date();
            var wd = d.getDay();
            var nwd = parseWeekday(bits[1]);

            // determine the number of days to subtract to get last weekday
            var addDays = (-1 * (wd + 7 - nwd)) % 7;

            // above calculate 0 if weekdays are the same so we have to change this to 7
            if (0 == addDays)
               addDays = -7;
            
            // adjust date and return
            d.setDate(d.getDate() + addDays);
            return d;

        }
    },
    // mm/dd/yyyy (American style)
    {   re: /(\d{1,2})\/(\d{1,2})\/(\d{4})/,
        handler: function(bits) {

            var yyyy = parseInt(bits[3], 10);
            var dd = parseInt(bits[2], 10);
            var mm = parseInt(bits[1], 10) - 1;

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // mm/dd/yy (American style) short year
    {   re: /(\d{1,2})\/(\d{1,2})\/(\d{1,2})/,
        handler: function(bits) {

            var d = new Date();
            var yyyy = d.getFullYear() - (d.getFullYear() % 100) + parseInt(bits[3], 10);
            var dd = parseInt(bits[2], 10);
            var mm = parseInt(bits[1], 10) - 1;

            if ( DateInRange(yyyy, mm, dd) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // mm/dd (American style) omitted year
    {   re: /(\d{1,2})\/(\d{1,2})/,
        handler: function(bits) {

            var d = new Date();
            var yyyy = d.getFullYear();
            var dd = parseInt(bits[2], 10);
            var mm = parseInt(bits[1], 10) - 1;

            if ( DateInRange(yyyy, mm, dd) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // yyyy-mm-dd (ISO style)
    {   re: /(\d{4})-(\d{1,2})-(\d{1,2})/,
        handler: function(bits) {

            var yyyy = parseInt(bits[1], 10);
            var dd = parseInt(bits[3], 10);
            var mm = parseInt(bits[2], 10) - 1;

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // yy-mm-dd (ISO style) short year
    {   re: /(\d{1,2})-(\d{1,2})-(\d{1,2})/,
        handler: function(bits) {

            var d = new Date();
            var yyyy = d.getFullYear() - (d.getFullYear() % 100) + parseInt(bits[1], 10);
            var dd = parseInt(bits[3], 10);
            var mm = parseInt(bits[2], 10) - 1;

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
    // mm-dd (ISO style) omitted year
    {   re: /(\d{1,2})-(\d{1,2})/,
        handler: function(bits) {

            var d = new Date();
            var yyyy = d.getFullYear();
            var dd = parseInt(bits[2], 10);
            var mm = parseInt(bits[1], 10) - 1;

            if ( DateInRange( yyyy, mm, dd ) )
               return getDateObj(yyyy, mm, dd);

        }
    },
];


function parseDateString(s) {
    for (var i = 0; i < dateParsePatterns.length; i++) {
        var re = dateParsePatterns[i].re;
        var handler = dateParsePatterns[i].handler;
        var bits = re.exec(s);
        if (bits) {
            return handler(bits);
        }
    }
    throw new Error("Invalid date string");
}


function magicDate(id) {
    var input = document.getElementById(id);
    var messagespan = input.id + 'Msg';
    try {
        var d = parseDateString(input.value);

        switch (configDateType) {
            case 'us':
                input.value = (d.getMonth() + 1) + '/' + d.getDate() + '/' + d.getFullYear();
                break;
            case 'iso':
            default:
                input.value = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
                break;
        }
                
        input.className = '';
        // Human readable date
        document.getElementById(messagespan).innerHTML = d.toDateString();
        document.getElementById(messagespan).className = 'normal';
    }
    catch (e) {
        input.className = 'error';
        var message = e.message;
        // Fix for IE6 bug
        if (message.indexOf('is null or not an object') > -1) {
            message = 'Invalid date string';
        }
        document.getElementById(messagespan).innerHTML = message;
        document.getElementById(messagespan).className = 'error';
    }
}
   