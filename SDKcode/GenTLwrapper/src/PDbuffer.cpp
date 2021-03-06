/*
 * @Author: Kian Liu
 * @Date: 2022-04-27 22:41:06
 * @LastEditTime: 2022-06-02 21:54:45
 * @LastEditors: Kian Liu
 * @Description:
 * @FilePath: /DYV_SDK/GenTLwrapper/src/PDbuffer.cpp
 */
#include "../inc/PDbuffer.h"
#include "../inc/sPDstream.h"

static cv::Mat emptyMat;

bool PDbuffer::releaseMat(PDHandle pHandle)
{
    if (pHandle != nullptr)
    {
        if (GenTL::DSQueueBuffer(hStream, pHandle) != GenTL::GC_ERR_SUCCESS)
        {
            PD_ERROR("failed DSQueueBuffer!\n");
            return false;
        }
    }
    return true;
}

PDbuffer::PDbuffer(sPDstream *stream)
{
    hStream = stream->getPort();
}

uint32_t PDbuffer::getMatNum()
{
    return (uint32_t)Mats.size();
}
const cv::Mat &PDbuffer::getMat(uint32_t id)
{
    if (id >= getMatNum())
    {
        return emptyMat;
    }
    return Mats[id];
}

std::shared_ptr<PDbuffer> sPDstream::waitFrames(uint64_t timeOut)
{
    auto ret = std::make_shared<PDbuffer>(this);

    ret->hBuffer = getMat(ret->Mats, timeOut);

    if (!ret->hBuffer)
    {
        ret.reset();
    }
    return ret;
}

PDbuffer::~PDbuffer()
{
    if (this->hBuffer)
    {
        releaseMat(this->hBuffer);
    }
}
