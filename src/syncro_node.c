// creates a period of exactly 4s with 
// clock divider = 8, timer divider = 8 and timer TOP = 0xFF
static const double _SN_CLOCK_RESET = 0;
static const double _SN_CLOCK_TOP = 62500;
static const double _SN_TICK_INCREMENT = 32;
static const double _SN_CORRECTION_THRESHOLD = 2;

static const double     _PI;
static const double _TWO_PI;

typedef struct _Syncro_Node_State {
    int tickSkips                    = 0;
    char isPhaseCorrectionUpdated    = 1;
    char isCommandFresh              = 0;
    int16_t nodePhaseError           = 0;
    int16_t nodePhaseCorrection      = 0;
    uint32_t nodeTime                = 0;
    uint16_t systemTime              = 0;
} SyncroNode;

double SN_calcClockPosition(SyncroNode* self) {
    return (self->nodeTime / _SN_CLOCK_TOP) * _TWO_PI;
}


void SN_tick(SyncroNode* self) {

    // adjust clock for phase error
    if (self->tickSkips > 0) { 
        self->tickSkips--;
        return;
    }

    // increment lighting pattern effect clock
    if (self->nodeTime < _SN_CLOCK_TOP) {
        self->nodeTime += _SN_TICK_INCREMENT;
    } else {
        self->nodeTime = _SN_CLOCK_RESET;
    }

}

void SN_addTickSkip(SyncroNode* self) {

    self->tickSkips++;

}

void SN_recordPhaseError(SyncroNode* self) {

    self->nodeTimeOffset = self->nodeTime;

}

void SN_setPhaseCorrectionStale(SyncroNode* self) {

    // recompute phase correction as soon as possible
    self->isPhaseCorrectionUpdated = 0;
}

// calculate correction for phase error
// NOTE: limit execution to once per clock tick
void SN_calcPhaseCorrection(SyncroNode* self) {

    // phase correction already updated in this cycle
    if (self->isPhaseCorrectionUpdated) return;

    // calculate phase error if a phase signal received
    if (self->nodeTimeOffset != 0) {

        // device is behind system time
        // phase error is negative
        if (self->nodeTimeOffset >= _SN_CLOCK_TOP/2) {
            self->nodePhaseError = (self->nodeTimeOffset - _SN_CLOCK_TOP) / _SN_TICK_INCREMENT;

        // device is ahead of system time
        // phase error is positive
        } else {
            self->nodePhaseError = self->nodeTimeOffset / _SN_TICK_INCREMENT;
        }

        // do not calculate phaseError again until another phase signal received
        self->nodeTimeOffset = 0;

    }

    // only apply correction if magnitude is greater than threshold
    // to minimize some chasing
    if (fabs(self->nodePhaseError) >= _SN_CORRECTION_THRESHOLD) { 

        // if phase error negative, add an extra clock tick
        // if positive, remove a clock tick
        if (self->nodePhaseError < 0) {
            SN_tick();
            self->nodePhaseError++;
        } else {
            SN_addTickSkip();
            self->nodePhaseError--;
        }        
        
    }

    // phase correction has been updated
    self->isPhaseCorrectionUpdated = 1;

}

