@file:JvmName("Meetup")

/**
 * Meetup exercise.
 * Finds the date of a recurring meetup.
 */
package meetup

// Standard library
import java.time.DayOfWeek
import java.time.LocalDate
/* Helper alias */
import kotlin.math.max

class Meetup(private val monthOfYear: Int, private val year: Int) {

    private val startOfMonth: LocalDate = LocalDate.of(year, monthOfYear, 1)

    fun day(dayOfWeek: DayOfWeek, schedule: MeetupSchedule): LocalDate {
        val days = generateSequence(startOfMonth) { it.plusDays(1) }
            .takeWhile { it.monthValue == monthOfYear }
            .filter { it.dayOfWeek == dayOfWeek }
            .toList()
        return days.first()
    }
}
