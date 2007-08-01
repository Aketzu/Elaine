/**
 * Function for formatting a length or timespan of form hh:mm:ss.
 * @param: accepts "hh:mm:mm", "mm:ss" or just seconds.
 * @returns: string in form "hh:mm:ss"
 */
function FormatLength(param)
{
  var times = param.split(':');
  var dt = new Date();

  dt.setHours(0)
  dt.setMinutes(0)
  dt.setSeconds(0)


  switch(times.length)
  {
    case 3:
      dt.setHours(parseFloat(times[0]))
      dt.setMinutes(parseFloat(times[1]))
      dt.setSeconds(parseFloat(times[2]))
      break;
    case 2:
      dt.setMinutes(parseFloat(times[0]))
			if (times[1] != "") {
	      dt.setSeconds(parseFloat(times[1]))
			}
      break;
    default:
      dt.setMinutes(parseFloat(times[0]))
      break;
  }

  return dt.toString().substr(16,8);
}

/**
 * Function for formatting time in hh:mm.
 * @param: accepts "hh:mm" only
 * @returns: boolean for validation
 */
function FormatTime(param)
{
  var times = param.split(':');
  var dt = new Date();

  dt.setHours(0)
  dt.setMinutes(0)
  dt.setSeconds(0)

  if(times.length == 2)
  {
      dt.setHours(parseFloat(times[0]))
      dt.setMinutes(parseFloat(times[1]))
  }
  else
    return;

  return dt.toString().substr(16,5);
}

