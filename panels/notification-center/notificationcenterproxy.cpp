// SPDX-FileCopyrightText: 2024 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: GPL-3.0-or-later

#include "notificationcenterproxy.h"

#include"notificationcenterpanel.h"

#include <QLoggingCategory>

namespace notification {
Q_DECLARE_LOGGING_CATEGORY(notificationCenterLog)

NotificationCenterProxy::NotificationCenterProxy(QObject *parent)
    : QObject(parent)
{
}

NotificationCenterProxy::~NotificationCenterProxy()
{
}

void NotificationCenterProxy::Toggle()
{
    if (panel()->visible()) {
        Hide();
    } else {
        Show();
    }
}

void NotificationCenterProxy::Show()
{
    qDebug(notificationCenterLog) << "Show notificationcenter";
    panel()->setVisible(true);
}

void NotificationCenterProxy::Hide()
{
    qDebug(notificationCenterLog) << "Hide notificationcenter";
    panel()->setVisible(false);
}

NotificationCenterPanel *NotificationCenterProxy::panel() const
{
    return qobject_cast<NotificationCenterPanel *>(parent());
}
}
