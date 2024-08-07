use log::LevelFilter;

static VERBOSITY: once_cell::sync::OnceCell<LevelFilter> = once_cell::sync::OnceCell::new();
static ALWAYS_PULL: once_cell::sync::OnceCell<bool> = once_cell::sync::OnceCell::new();
static NO_RUN: once_cell::sync::OnceCell<bool> = once_cell::sync::OnceCell::new();

pub fn verbosity() -> &'static LevelFilter {
    match VERBOSITY.get() {
        Some(value) => &value,
        None => &LevelFilter::Trace,
    }
}

pub fn set_global_verbosity(verbosity: LevelFilter) {
    VERBOSITY.set(verbosity).expect("could not set verbosity")
}

pub fn set_global_always_pull(always_pull: bool) {
    ALWAYS_PULL
        .set(always_pull)
        .expect("could not set always_pull")
}
pub fn always_pull() -> &'static bool {
    match ALWAYS_PULL.get() {
        Some(value) => &value,
        None => &false,
    }
}

pub fn set_global_no_run(no_run: bool) {
    NO_RUN.set(no_run).expect("could not set no_run")
}

pub fn no_run() -> &'static bool {
    match NO_RUN.get() {
        Some(value) => &value,
        None => &false,
    }
}
